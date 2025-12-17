{ inputs, ... }:
{
  imports = [
    ./ai-code-editors.nix   # ai code editors: claude, cursor, gemini-cli
    ./boot.nix              # bootloader and kernel configuration
    ./browsers-extra.nix    # additional browsers beyond firefox
    ./communication.nix     # communication apps: discord, teams, zoom, telegram
    ./dotbot.nix            # dotfile symlink manager
    ./gaming-support.nix    # gaming: controllers, gamescope, protonup-qt
    ./fonts.nix             # system font configuration
    ./greetd.nix            # login manager for niri
    ./hardware.nix          # hardware support: bluetooth, sound, power management
    ./network.nix           # network configuration and firewall
    ./nfs.nix               # network file system support
    ./nh.nix                # nix helper tool for easier rebuilds
    ./packages.nix          # core system packages
    ./printing.nix          # printing and scanning support
    ./productivity.nix      # productivity apps: obsidian, quickemu
    ./security.nix          # security settings: polkit, gnome-keyring
    ./services.nix          # system services: dbus, gnome services
    ./starship.nix          # starship prompt configuration
    ./steam.nix             # steam gaming platform
    ./syncthing.nix         # file synchronization service
    ./system.nix            # core system settings: locale, timezone
    ./thunar.nix            # thunar file manager
    ./user.nix              # user account and home-manager configuration
    ./virtualisation.nix    # docker and libvirt/virt-manager
    ./xserver.nix           # x11 configuration and xwayland support
  ];
}
