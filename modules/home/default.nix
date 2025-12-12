{
  inputs,
  host,
  lib,
  ...
}:
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
    # window manager / compositor - managed via dotfiles
    # ./niri
    # ./xdg.nix
    # bar - managed via dotfiles
    # ./noctalia-shell
    #./qt.nix
    # shells - managed via dotfiles
    # ./fish
    #./fish/fishrc-personal.nix
    # shell tools - managed via dotfiles
    # ./bat.nix
    # ./bottom.nix
    # ./btop.nix
    # ./cava.nix
    # ./emoji.nix
    # ./eza.nix
    ./fastfetch
    # ./fzf.nix
    # ./gh.nix
    # ./git.nix
    # ./gtk.nix
    # ./htop.nix
    # terminal emulators - managed via dotfiles
    # ./foot.nix
    # ./lazygit.nix
    # ./starship.nix
    # ./tealdeer.nix
    # ./qt.nix
    ./virtmanager.nix
    # ./yazi
    ./zoxide.nix
    # ./environment.nix
    # editors
    ./vscode.nix
    # programs
    ./obs-studio.nix
    # theming
    # ./stylix.nix  # disabled - configs managed via dotfiles
    # other
    ./scripts

  ];
}
