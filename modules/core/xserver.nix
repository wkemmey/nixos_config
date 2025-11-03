{ host, lib, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) keyboardLayout;
in
{
  services.xserver = {
    enable = lib.mkDefault false;
    xkb = {
      layout = "${keyboardLayout}";
      variant = "";
    };
  };
}
