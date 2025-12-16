{ config, lib, pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) aiCodeEditorsEnable;
in
{
  config = lib.mkIf aiCodeEditorsEnable {
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
    ];
  };
}
