{ inputs, ... }:
{
  imports = [
    ./boot.nix             # bootloader and kernel configuration
    ./dotbot.nix           # dotfile symlink manager
    ./fonts.nix            # system font configuration
    ./gaming.nix           # gaming: launchers, controllers, gamescope
    ./login.nix            # login manager
    ./hardware.nix         # hardware support: bluetooth, sound, power management
    ./network.nix          # network configuration and firewall
    ./nfs.nix              # network file system support
    ./niri.nix             # niri wayland compositor configuration
    ./obsidian.nix         # obsidian vault git backup timer
    ./packages.nix         # core system packages
    ./printing.nix         # printing and scanning support
    ./print-test.nix       # weekly print-head maintenance test page
    ./security.nix         # security settings: polkit, gnome-keyring
    ./services.nix         # system services: dbus, gnome services
    ./starship.nix         # starship prompt configuration
    ./syncthing.nix        # file synchronization service
    ./system.nix           # core system settings: locale, timezone
    ./thunar.nix           # thunar file manager
    ./user.nix             # user account and home-manager configuration
    ./virtualisation.nix   # docker and libvirt/virt-manager
  ];
}
