{ pkgs, host, ... }: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    firewall = {
      enable = true;
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
