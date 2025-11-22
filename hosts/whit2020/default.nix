{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Keep niri available at system level and ensure session package is present
  programs.niri.package = pkgs.niri;
  services.displayManager.sessionPackages = [ pkgs.niri ];
}
