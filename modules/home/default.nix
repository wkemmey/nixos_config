{ inputs, host, lib, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) waybarChoice;

  # new variable system
  windowManager = variables.windowManager or "hyprland";
  # prefer noctalia as the default status bar
  barChoice = variables.barChoice or "noctalia";
  defaultShell = variables.defaultShell or "zsh";

  # bar and shell defaults
  # (dms support removed; prefer explicit `barChoice` in host variables)

in
{
  imports = [
    ./virtmanager.nix
    ./vscode.nix
    ./obs-studio.nix
    ./scripts
  ];
}
