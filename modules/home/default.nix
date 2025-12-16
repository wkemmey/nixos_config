{ inputs, host, lib, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) waybarChoice;

  # New variable system
  windowManager = variables.windowManager or "hyprland";
  # Prefer Noctalia as the default status bar
  barChoice = variables.barChoice or "noctalia";
  defaultShell = variables.defaultShell or "zsh";

  # Bar and shell defaults
  # (DMS support removed; prefer explicit `barChoice` in host variables)

in
{
  imports = [
    ./virtmanager.nix
    ./vscode.nix
    ./obs-studio.nix
    ./scripts
  ];
}
