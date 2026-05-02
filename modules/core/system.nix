{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap timeZone;
in
{
  nix = {
    settings = {
      download-buffer-size = 250000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"  # default nixos binary cache
        "https://devenv.cachix.org" # pre-built devenv packages (avoids building from source)
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };
  time.timeZone = "${timeZone}";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  environment.variables = {
  };
  
  # force electron apps (vscode, etc.) to use native wayland rendering
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # tells electron apps to use wayland natively if available
    # note: auto is typically safer than wayland directly
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
  
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "25.11"; # do not change!

  # enable nix-ld for running unpackaged programs like adb
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # common libraries needed for android tools
    #stdenv.cc.cc.lib
    #zlib
    #openssl
    #libGL
  ];
}
