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
    # window manager / compositor
    ./niri
    ./xdg.nix
    # bar
    ./noctalia-shell
    ./qt.nix
    # shells
    ./bash.nix
    ./bashrc-personal.nix
    ./fish
    ./fish/fishrc-personal.nix
    # shell tools
    ./bat.nix
    ./bottom.nix
    ./btop.nix
    ./cava.nix
    ./emoji.nix
    ./eza.nix
    ./fastfetch
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gtk.nix # TODO do i need
    ./htop.nix
    # terminal emulators
    ./alacritty.nix
    ./foot.nix
    ./lazygit.nix

    ./starship.nix
    ./swappy.nix # TODO do i need
    ./tealdeer.nix
    ./tmux.nix # TODO don't think i need now but maybe in the future
    ./virtmanager.nix
    ./wlogout
    ./yazi
    ./zoxide.nix
    ./environment.nix
    # editors
    ./vscode.nix
    # programs
    ./obs-studio.nix
    # theming
    ./stylix.nix
    # other
    ./scripts

  ];
}
