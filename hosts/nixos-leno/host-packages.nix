{ config, lib, pkgs, ... }:
let
  inherit (import ./variables.nix)
    davinciResolveEnable;
in
{
  environment.systemPackages = with pkgs; [
    audacity
    discord
    nodejs
  ] ++ lib.optionals davinciResolveEnable [
    davinci-resolve
  ];
}
