{host, pkgs, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) enablePrint;
in {
  services = {
    printing = {
      enable = enablePrint;
      drivers = [
        pkgs.gutenprint # epson driver support
        pkgs.gutenprintBin # additional epson utilities
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
  };
  
  # add scanner utilities
  environment.systemPackages = with pkgs; [
    simple-scan # gnome scanner app (gtk4, wayland-native)
    # skanlite # alternative: kde scanner app (qt, wayland-native)
  ];
}
