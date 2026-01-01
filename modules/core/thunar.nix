{ host, pkgs, ... }: 
let
  inherit (import ../../hosts/${host}/variables.nix) enableThunar;
in {
  programs = {
    thunar = {
      enable = enableThunar;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer # Need For Video / Image Preview
  ];
}
