{ config, lib, pkgs, host, ...}:
let
  inherit (import ../../hosts/${host}/variables.nix) enableCommunicationApps;
in
{
  config = lib.mkIf enableCommunicationApps {
    environment.systemPackages = with pkgs; [
      zoom-us # video meetings
      #vesktop # discord alternative
    ];
  };
}
