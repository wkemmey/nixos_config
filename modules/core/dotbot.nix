{ config, pkgs, ... }:

{
  # Install dotbot for dotfiles management
  environment.systemPackages = with pkgs; [
    dotbot
  ];

  # Run dotbot on system activation to create symlinks
  system.activationScripts.dotbot = ''
    # Run dotbot as the user to create symlinks in home directory
    ${pkgs.sudo}/bin/sudo -u ${config.users.users.${config.users.users ? "whit" or "root"}.name} \
      ${pkgs.dotbot}/bin/dotbot \
      -d /home/whit/nixos_config/dotfiles \
      -c /home/whit/nixos_config/dotfiles/install.conf.yaml
  '';
}
