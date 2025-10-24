# nixos_config
My NixOS configuration using flakes and home manager.

- install git
- git clone https://github.com/wkemmey/nixos_config
- cd nixos_config
- make sure hostname on machine matches configuration files
- sudo nixos-rebuild switch --impure --flake .


# to install

- make gui-less usb media and boot from it
- default user is nixos with no password
- sudo -i
- ping to check networking (may need to configure network with ifconfig if no dhcp on network, or use graphical installer, or see https://nixos.org/manual/nixos/stable/#sec-installation)
- lsblk to find name of disk device
- for uefi/gpt:
- parted /dev/sda -- mklabel gpt
- parted /dev/sda -- mkpart root ext4 512MB -8GB
- parted /dev/sda -- mkpart swap linux-swap -8GB 100%
- parted /dev/sda -- mkpart ESP fat32 1MB 512MB
- parted /dev/sda -- set 3 esp on
- 

# references
  https://librephoenix.com/2024-01-28-program-a-modular-control-center-for-your-config-using-special-args-in-nixos-flakes.html
  https://librephoenix.com/2023-12-26-nixos-conditional-config-and-custom-options


  https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles

  https://www.tonybtw.com/tutorial/nixos-hyprland/

  https://discourse.nixos.org/t/minimal-hyprland-waybar-setup/63304