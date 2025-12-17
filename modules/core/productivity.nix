{ config, lib, pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enableProductivityApps;
in
{
  config = lib.mkIf enableProductivityApps {
    environment.systemPackages = with pkgs; [
      obsidian # note-taking app
      quickemu # fast vm creation tool
      quickgui # optional gui for quickemu
    ];
  };
}
