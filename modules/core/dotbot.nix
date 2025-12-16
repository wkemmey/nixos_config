{ config, pkgs, ... }:

{
  # install dotbot for dotfiles management
  environment.systemPackages = with pkgs; [
    dotbot
  ];

  # run dotbot on system activation to create symlinks
  system.activationScripts.dotbot = ''
    # run dotbot as the user to create symlinks in home directory
    ${pkgs.sudo}/bin/sudo -u whit \
      ${pkgs.dotbot}/bin/dotbot \
      -d /home/whit/nixos_config/dotfiles \
      -c /home/whit/nixos_config/dotfiles/install.conf.yaml
  '';
}
