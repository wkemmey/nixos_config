{
  config,
  pkgs,
  lib,
  host,
  username,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  # directory holding nordlynx.key (your NordLynx private key, nothing else)
  confDir = variables.vpnConfigDirectory or "";
  stateDir = "/var/lib/nordvpn";

  # The script must run as root: `sudo vpn on us` (password required), or from
  # the boot service. There is deliberately no NOPASSWD rule. Since it runs as
  # root:
  #   - PATH is fixed here (sudo keeps the caller's PATH otherwise)
  #   - the key is validated before it is written into the config
  #   - the config (/etc/wireguard) and state (/var/lib) are root-owned
  #   - arguments are only ever used as data (jq --arg), never as code or paths
  safePath =
    lib.makeBinPath (
      with pkgs;
      [
        coreutils
        gnugrep
        gawk
        curl
        jq
        iproute2
        wireguard-tools
        systemd
      ]
    )
    + ":/run/current-system/sw/bin";

  vpnScript = pkgs.writeShellScriptBin "vpn" ''
    set -euo pipefail
    export PATH="${safePath}"

    key_file="${confDir}/nordlynx.key"
    state_dir="${stateDir}"
    iface="nordlynx"
    conf="/etc/wireguard/$iface.conf"       # generated; holds the private key (0600)
    last_file="$state_dir/last-country"     # argument of the last `vpn on`
    current_file="$state_dir/current"       # description of the connected server
    nord_dns="103.86.96.100"
    api_url="https://api.nordvpn.com/v1"

    usage() {
      echo "Usage: vpn <command> [args]"
      echo
      echo "Commands:"
      echo "  on [country]   connect to the best (nearest, least loaded) NordVPN server"
      echo "                 in a country, e.g. 'vpn on us', 'vpn on bahamas', 'vpn on gb'."
      echo "                 With no country: reuse the last one, or the best server overall."
      echo "  off            disconnect"
      echo "  boot           like 'on', but first look up the country you are physically in"
      echo "                 (while disconnected) and use that; used by the boot service"
      echo "  status         show whether connected, and to which server"
      echo "  verify         check the tunnel: handshake, Nord sees us as protected,"
      echo "                 DNS goes through the tunnel, no IPv6 leak"
      echo "  help           show this help"
    }

    cmd="''${1:-status}"
    case "$cmd" in
      help|-h|--help) usage; exit 0 ;;
    esac

    if [ "$(id -u)" -ne 0 ]; then
      echo "error: must run as root: sudo vpn $cmd" >&2
      exit 1
    fi
    shift || true

    # write a file, replacing anything already there
    put() {
      rm -f "$1"
      printf '%s\n' "$2" > "$1"
    }

    api() {
      curl -q -sf --max-time 20 --retry 5 --retry-delay 2 --retry-all-errors "$@"
    }

    is_up() {
      [ -d "/sys/class/net/$iface" ]
    }

    # seconds since the last handshake (empty if there has been none)
    handshake_age() {
      ts="$(wg show "$iface" latest-handshakes 2>/dev/null | awk 'NR==1 {print $2}')"
      if [ -n "$ts" ] && [ "$ts" -gt 0 ]; then
        echo $(( $(date +%s) - ts ))
      fi
    }

    disconnect() {
      if is_up; then
        if [ -f "$conf" ]; then
          wg-quick down "$conf" >/dev/null 2>&1 || true
        else
          ip link delete dev "$iface" 2>/dev/null || true
        fi
      fi
      rm -f "$current_file"
    }

    # country name or ISO code -> Nord country id
    country_id() {
      q="$(printf '%s' "$1" | tr '[:upper:]_-' '[:lower:]  ')"
      case "$q" in
        uk) q="gb" ;;
        usa) q="us" ;;
      esac
      api "$api_url/servers/countries" \
        | jq -r --arg q "$q" \
            'map(select((.name | ascii_downcase) == $q or (.code | ascii_downcase) == $q)) | .[0].id // empty'
    }

    case "$cmd" in
      on|boot)
        if [ "$cmd" = boot ]; then
          # Connect to the country we are physically in. Must look it up while
          # disconnected, or Nord would report the VPN exit's country.
          disconnect
          country="$(api "$api_url/helpers/ips/insights" | jq -r '.country_code // empty' 2>/dev/null || true)"
          if ! [[ "$country" =~ ^[A-Z]{2}$ ]]; then
            # lookup failed: fall back to the last country, if any
            country=""
            [ -f "$last_file" ] && country="$(cat "$last_file")"
          fi
        elif [ $# -gt 0 ]; then
          country="$1"
        elif [ -f "$last_file" ]; then
          country="$(cat "$last_file")"
          if is_up; then
            echo "Already connected: $(cat "$current_file" 2>/dev/null || echo "$iface")"
            exit 0
          fi
        else
          country=""
        fi
        if [ -n "$country" ] && ! [[ "$country" =~ ^[A-Za-z][A-Za-z\ _-]{0,39}$ ]]; then
          echo "error: invalid country '$country'" >&2
          exit 1
        fi

        if [ ! -r "$key_file" ]; then
          echo "error: cannot read $key_file" >&2
          exit 1
        fi
        privkey="$(tr -d '[:space:]' < "$key_file")"
        # strict format check: it is written into a config that root will run
        if ! [[ "$privkey" =~ ^[A-Za-z0-9+/]{43}=$ ]]; then
          echo "error: $key_file does not look like a WireGuard key" >&2
          exit 1
        fi

        # `on` disconnects here so Nord picks the server for our real location.
        # The `boot` path already disconnected above (before the country lookup).
        if [ "$cmd" = on ]; then
          disconnect
        fi

        filter=""
        if [ -n "$country" ]; then
          id="$(country_id "$country" || true)"
          if ! [[ "$id" =~ ^[0-9]+$ ]]; then
            echo "error: unknown country '$country'" >&2
            exit 1
          fi
          filter="&filters%5Bcountry_id%5D=$id"
        fi

        # Nord ranks recommendations by distance and load; take the top one
        rec="$(api "$api_url/servers/recommendations?limit=1&filters%5Bservers.status%5D=online&filters%5Bservers_technologies%5D=35$filter" || true)"
        line="$(printf '%s' "$rec" | jq -r '
          .[0] // empty
          | [ .hostname,
              .station,
              (.technologies[] | select(.id == 35) | .metadata[] | select(.name == "public_key") | .value),
              (.locations[0].country.city.name // "unknown"),
              (.locations[0].country.name // "unknown") ]
          | join("|")' 2>/dev/null || true)"
        if [ -z "$line" ]; then
          echo "error: no WireGuard server available (API unreachable or no match)" >&2
          exit 1
        fi
        IFS="|" read -r hostname endpoint pubkey city cname <<< "$line"
        # these come from the network and end up in a config root will run
        if ! [[ "$endpoint" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] \
          || ! [[ "$pubkey" =~ ^[A-Za-z0-9+/]{43}=$ ]]; then
          echo "error: unexpected server data for '$hostname'" >&2
          exit 1
        fi

        rm -f "$conf"
        (
          umask 077
          printf '[Interface]\nPrivateKey = %s\nAddress = 10.5.0.2/32\nDNS = %s, 103.86.99.100\n\n[Peer]\nPublicKey = %s\nAllowedIPs = 0.0.0.0/0, ::/0\nEndpoint = %s:51820\nPersistentKeepalive = 25\n' \
            "$privkey" "$nord_dns" "$pubkey" "$endpoint" > "$conf"
        )

        if ! wg-quick up "$conf" >/dev/null; then
          echo "error: wg-quick failed to bring up $iface" >&2
          exit 1
        fi

        # make sure the server actually answered
        age=""
        for _ in 1 2 3 4 5 6 7 8 9 10; do
          age="$(handshake_age || true)"
          [ -n "$age" ] && break
          sleep 1
        done
        if [ -z "$age" ]; then
          wg-quick down "$conf" >/dev/null 2>&1 || true
          echo "error: no handshake with $hostname ($endpoint); disconnected" >&2
          exit 1
        fi

        put "$last_file" "$country"
        put "$current_file" "$hostname - $city, $cname ($endpoint)"
        echo "Connected to $hostname - $city, $cname"
        ;;
      off)
        if is_up; then
          desc="$(cat "$current_file" 2>/dev/null || echo "$iface")"
          disconnect
          echo "Disconnected from $desc"
        else
          rm -f "$current_file"
          echo "Not connected"
        fi
        ;;
      status)
        if is_up; then
          age="$(handshake_age || true)"
          echo "Connected to $(cat "$current_file" 2>/dev/null || echo "$iface")"
          if [ -n "$age" ]; then
            echo "Last handshake: ''${age}s ago"
          else
            echo "Last handshake: none yet"
          fi
        else
          rm -f "$current_file"
          echo "Not connected"
        fi
        ;;
      verify)
        bad=0
        ok()   { echo "  ok    $*"; }
        fail() { echo "  FAIL  $*"; bad=1; }

        if ! is_up; then
          echo "  FAIL  not connected"
          exit 1
        fi
        ok "interface $iface is up ($(cat "$current_file" 2>/dev/null || true))"

        # 1. the server is answering (handshakes renew about every 2 minutes)
        age="$(handshake_age || true)"
        if [ -n "$age" ] && [ "$age" -lt 180 ]; then
          ok "handshake ''${age}s ago"
        else
          fail "no recent handshake (''${age:-none})"
        fi

        # 2. Nord itself sees our traffic arriving from one of its servers
        info="$(api "$api_url/helpers/ips/insights" || true)"
        if [ "$(printf '%s' "$info" | jq -r '.protected' 2>/dev/null || true)" = "true" ]; then
          ok "Nord reports protected: $(printf '%s' "$info" | jq -r '"\(.ip) (\(.city), \(.country))"')"
        else
          fail "Nord does not report this connection as protected (ip: $(printf '%s' "$info" | jq -r '.ip // "unknown"' 2>/dev/null))"
        fi

        # 3. DNS queries go through the tunnel
        dns="$(resolvectl dns "$iface" 2>/dev/null || true)"
        domains="$(resolvectl domain "$iface" 2>/dev/null || true)"
        if printf '%s' "$dns" | grep -q "$nord_dns" && printf '%s' "$domains" | grep -q '~\.'; then
          ok "DNS routed through the tunnel ($nord_dns)"
        else
          fail "DNS is not routed through the tunnel"
        fi

        # 4. IPv6 cannot bypass the tunnel (it is routed into it and dropped)
        v6="$(ip -6 route get 2606:4700:4700::1111 2>&1 || true)"
        if printf '%s' "$v6" | grep -q "dev $iface" || ! printf '%s' "$v6" | grep -q ' dev '; then
          ok "no IPv6 leak"
        else
          fail "IPv6 traffic bypasses the tunnel"
        fi

        if [ "$bad" -eq 0 ]; then
          echo "VPN is working"
        else
          echo "VPN has problems"
          exit 1
        fi
        ;;
      *)
        echo "unknown command: $cmd (run: vpn help)" >&2
        exit 1
        ;;
    esac
  '';
in
lib.mkIf (variables.enableVPN or false) {
  environment.systemPackages = [
    vpnScript
    pkgs.wireguard-tools # wg + wg-quick
    pkgs.curl
    pkgs.jq
  ];

  # systemd-resolved so wg-quick can route DNS through the tunnel (avoids leaks)
  services.resolved.enable = true;

  # root-owned: generated config (holds the private key) and last-used country.
  # (also fixes ownership of the state dir created by older versions)
  systemd.tmpfiles.rules = [
    "d /etc/wireguard 0700 root root -"
    "d ${stateDir} 0755 root root -"
  ];

  # auto-connect at boot (to the country we are physically in; that country
  # then becomes the default for `vpn on` for the rest of the session)
  systemd.services.nordvpn = {
    description = "NordVPN (NordLynx) auto-connect";
    after = [
      "network-online.target"
      "systemd-resolved.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = "${vpnScript}/bin/vpn boot";
  };
}
