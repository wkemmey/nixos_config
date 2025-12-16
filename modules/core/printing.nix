{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) enablePrint;
in {
  services = {
    printing = {
      enable = enablePrint;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    avahi = {
      enable = enablePrint;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = enablePrint;
  };
}
