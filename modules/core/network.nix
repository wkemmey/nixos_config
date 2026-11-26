{ pkgs, host, ... }: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # wg-quick full-tunnel: the reverse-path check would drop the WireGuard
      # handshake reply (reverse lookup routes via the tunnel table)
      checkReversePath = "loose";
      allowedTCPPorts = [
        17500 # dropbox lan sync
      ];
      allowedUDPPorts = [
        17500 # dropbox lan sync
      ];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
