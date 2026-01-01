{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];
}
