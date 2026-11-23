{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enablePrint;
in
{
  services = {
    printing = {
      enable = enablePrint;
      drivers = [
        pkgs.gutenprint # printer drivers (epson, canon, hp, ...)
      ];
    };
    avahi = {
      enable = enablePrint;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = enablePrint;
  };

  # enable scanning support
  hardware.sane = {
    enable = enablePrint;
    extraBackends = [ pkgs.sane-airscan ]; # network scanner support
    disabledDefaultBackends = [ "escl" ]; # airscan has its own escl backend
  };

  # add scanner utilities
  environment.systemPackages = with pkgs; [
    simple-scan # gnome scanner app (gtk4, wayland-native)
    # skanlite # alternative: kde scanner app (qt, wayland-native)
  ];
}
