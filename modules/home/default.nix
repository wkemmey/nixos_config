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
  barChoice = variables.barChoice or "waybar";
  defaultShell = variables.defaultShell or "zsh";

  # Legacy variable support (backwards compatibility)
  enableDMS = variables.enableDankMaterialShell or false;
  legacyBarChoice = if enableDMS then "dms" else "waybar";
  actualBarChoice = if variables ? barChoice then barChoice else legacyBarChoice;

in
{
  imports = [
    #./amfora.nix
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
    #./emoji.nix
    ./eza.nix
    ./fastfetch
    ./fzf.nix
    ./gh.nix
    #./ghostty.nix
    ./git.nix
    ./gtk.nix # TODO do i need
    ./htop.nix
    #./kitty.nix
    ./lazygit.nix
    #./nvf.nix
    ./nwg-drawer.nix # TODO do i need
    ./rofi # TODO do i need
    ./starship.nix
    ./swappy.nix # TODO do i need
    ./tealdeer.nix
    ./tmux.nix # TODO don't think i need now but maybe in the future
    #./virtmanager.nix
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
