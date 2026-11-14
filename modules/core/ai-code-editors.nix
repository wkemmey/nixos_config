{ config, lib, pkgs, host, inputs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enableAiCodeEditors;
in
{
  config = lib.mkIf enableAiCodeEditors {
    nixpkgs.overlays = [
      (final: prev: {
        opencode = inputs.unstable.legacyPackages.${prev.system}.opencode;
      })
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        #"cursor"
        "claude"
      ];

    environment.systemPackages = with pkgs; [
      # ai-powered code editors and development tools
      # code-cursor # ai ide (currently commented out - uncomment if needed)
      claude-code # claude ai native development environment
      gemini-cli # google gemini cli tool for terminal ai assistance
      aider-chat # terminal-based agentic ai coding assistant
      opencode # terminal ai coding agent
    ];
  };
}
