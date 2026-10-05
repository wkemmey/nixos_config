{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      # enable steam input for controller support
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            # controller support libraries
            libusb1
            udev
            SDL2

            # additional libraries for better compatibility
            libxcursor
            libxi
            libxinerama
            libxscrnsaver
            libxcomposite
            libxdamage
            libxrender
            libxext

            # fix for xwayland symbol errors
            libkrb5
            keyutils
          ];
      };
    };
  };

  # system-level packages
  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
