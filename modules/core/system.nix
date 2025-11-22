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
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
    ZANEYOS_VERSION = "2.3.1";
    ZANEYOS = "true";
  };
  
  # Force Electron apps (VSCode, etc.) to use native Wayland rendering
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # Tells Electron apps to use Wayland natively if available
    # Note: auto is typically safer than wayland directly
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
  
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "25.05"; # Do not change!

  # Enable nix-ld for running unpackaged programs like adb
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Common libraries needed for Android tools
    stdenv.cc.cc.lib
    zlib
    openssl
    libGL
  ];
}
