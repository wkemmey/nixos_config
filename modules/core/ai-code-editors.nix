{ config, lib, pkgs, host, inputs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enableAiCodeEditors;
in
{
  config = lib.mkIf enableAiCodeEditors {
    nixpkgs.overlays = [
      (final: prev: {
        opencode = inputs.unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.opencode;
      })
    ];

    environment.systemPackages = with pkgs; [
      # ai-powered code editors and development tools
      # code-cursor # ai ide (currently commented out - uncomment if needed)
      opencode # terminal ai coding agent
    ];
  };
}
