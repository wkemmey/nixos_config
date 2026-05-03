{ pkgs, host, options, ... }: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        17500
        59010
        59011
        8080
      ];
      allowedUDPPorts = [
        17500
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
