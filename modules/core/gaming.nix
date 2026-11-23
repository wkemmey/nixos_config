{ host, pkgs, lib, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enableGamingSupport;
in
lib.mkIf enableGamingSupport {
  # steam input virtual controller
  boot.kernelModules = [ "uinput" ];

  # controller udev rules and drivers
  hardware = {
    steam-hardware.enable = true;  # steam's udev rules (controllers, vr, etc.)
    xone.enable = true;            # xbox one/series controllers + wireless usb adapter
  };

  environment.systemPackages = with pkgs; [
    heroic       # epic games + gog + amazon
    lutris       # battle.net + gog + other windows/native games
    protonup-qt  # install GE-Proton / Wine-GE for steam, heroic, lutris
    protontricks # manage proton wine prefixes
    gamescope    # micro-compositor for wayland gaming
  ];
}
