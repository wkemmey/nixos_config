{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) enableCommunicationApps;
in
{
  config = lib.mkIf enableCommunicationApps {
    environment.systemPackages = with pkgs; [
      zoom-us # Video Meetings
      #vesktop # Discord Alternative
    ];
  };
}
