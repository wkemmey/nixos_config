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
  confDir = variables.vpnConfigDirectory or "";
  wg = "${pkgs.wireguard-tools}/bin/wg";
  wgQuick = "${pkgs.wireguard-tools}/bin/wg-quick";
  curl = "${pkgs.curl}/bin/curl";
  awk = "${pkgs.gawk}/bin/awk";
  stateDir = "/var/lib/nordvpn";

  vpnScript = pkgs.writeShellScriptBin "vpn" ''
    set -euo pipefail

    conf_dir="${confDir}"
    state_dir="${stateDir}"
    last_file="$state_dir/last-server"
    iface_file="$state_dir/iface"

    # wg-quick needs root; when run by the user (not the boot service) use sudo
    SUDO=""
    [ "$(id -u)" -ne 0 ] && SUDO="/run/wrappers/bin/sudo"

    servers() {
      ls "$conf_dir"/*.conf 2>/dev/null \
        | xargs -r -n1 basename \
        | sed 's/\.conf$//' \
        | sort
    }

    cmd="''${1:-status}"
    shift || true

    case "$cmd" in
      on)
        if [ $# -gt 0 ]; then
          server="$1"
        elif [ -f "$last_file" ]; then
          server="$(cat "$last_file")"
        else
          server="$(ls "$conf_dir"/ashburn*.conf 2>/dev/null | xargs -r -n1 basename | sed 's/\.conf$//' | head -1)"
        fi
        if [ -z "$server" ] || [ ! -f "$conf_dir/$server.conf" ]; then
          echo "error: no config for '$server'" >&2
          exit 1
        fi
        if [ -f "$iface_file" ] && [ "$(cat "$iface_file")" = "$server" ] && [ -d "/sys/class/net/$server" ]; then
          echo "Already connected to $server"
          exit 0
        fi
        if [ -f "$iface_file" ]; then
          $SUDO ${wgQuick} down "$conf_dir/$(cat "$iface_file").conf" >/dev/null 2>&1 || true
        fi
        $SUDO ${wgQuick} up "$conf_dir/$server.conf"
        echo "$server" > "$last_file"
        echo "$server" > "$iface_file"
        echo "Connected to $server"
        ;;
      off)
        if [ -f "$iface_file" ]; then
          server="$(cat "$iface_file")"
          $SUDO ${wgQuick} down "$conf_dir/$server.conf"
          rm -f "$iface_file"
          echo "Disconnected from $server"
        else
          echo "Not connected"
        fi
        ;;
      list)
        servers
        ;;
      status)
        if [ -f "$iface_file" ]; then
          server="$(cat "$iface_file")"
          if [ -d "/sys/class/net/$server" ]; then
            echo "Connected to $server"
          else
            rm -f "$iface_file"
            echo "Not connected"
          fi
        else
          echo "Not connected"
        fi
        ;;
      verify)
        ip="$(${curl} -s --max-time 10 https://ipinfo.io/ip || true)"
        echo "Public IP: ''${ip:-unknown}"
        ;;
      speed)
        filter="''${1:-}"
        names="$(servers | grep "^$filter" || true)"
        if [ -z "$names" ]; then
          echo "no servers match '$filter'" >&2
          exit 1
        fi
        had=""
        if [ -f "$iface_file" ]; then
          had="$(cat "$iface_file")"
        fi
        best=""
        best_bps=0
        for server in $names; do
          if ! $SUDO ${wgQuick} up "$conf_dir/$server.conf" >/dev/null 2>&1; then
            echo "  $server: failed to connect"
            continue
          fi
          bps="$(${curl} -o /dev/null -s --max-time 30 -w '%{speed_download}' \
            'https://speed.cloudflare.com/__down?bytes=25000000' 2>/dev/null || echo 0)"
          $SUDO ${wgQuick} down "$conf_dir/$server.conf" >/dev/null 2>&1
          mbps="$(${awk} -v b="$bps" 'BEGIN { printf "%.1f", b*8/1000000 }')"
          echo "  $server: $mbps Mbit/s"
          if [ "$(${awk} -v a="$bps" -v b="$best_bps" 'BEGIN { print (a>b)?1:0 }')" = "1" ]; then
            best="$server"
            best_bps="$bps"
          fi
        done
        if [ -n "$had" ]; then
          $SUDO ${wgQuick} up "$conf_dir/$had.conf" >/dev/null 2>&1
          echo "$had" > "$iface_file"
          echo "Reconnected to $had"
        elif [ -n "$best" ]; then
          $SUDO ${wgQuick} up "$conf_dir/$best.conf" >/dev/null 2>&1
          echo "$best" > "$iface_file"
          echo "$best" > "$last_file"
          echo "Connected to fastest: $best"
        fi
        ;;
      help|-h|--help)
        echo "Usage: vpn <command> [args]"
        echo
        echo "Commands:"
        echo "  on [name]      connect to a server (last-used or first ashburn if none)"
        echo "  off            disconnect"
        echo "  list           list available servers"
        echo "  status         show connection state and current server"
        echo "  verify         print your public IP (should be a NordVPN address)"
        echo "  speed [filter] test download speed of servers starting with <filter>,"
        echo "                 then connect to the fastest"
        echo "  help           show this help"
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
    pkgs.curl # verify + speed tests
  ];

  # systemd-resolved so wg-quick can route DNS through the tunnel (avoids leaks)
  services.resolved.enable = true;

  # shared state dir, owned by the user so both root (boot service) and the
  # user's shell can read/write the last-connected server
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0755 ${username} users -"
  ];

  # passwordless sudo for wg-quick so `vpn on/off/speed` don't prompt
  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "${pkgs.wireguard-tools}/bin/wg-quick";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # auto-connect at boot (to the last-used server, or first ashburn)
  systemd.services.nordvpn = {
    description = "NordVPN (NordLynx) auto-connect";
    after = [
      "network-online.target"
      "systemd-resolved.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      coreutils
      findutils
      gnugrep
      gnused
      gawk
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = username;
      Group = "users";
    };
    script = "${vpnScript}/bin/vpn on";
  };
}
