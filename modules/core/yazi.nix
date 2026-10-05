{ pkgs, username, ... }:
let
  plugins = {
    git = pkgs.yaziPlugins.git;
    smart-enter = pkgs.yaziPlugins.smart-enter;
  };
  linkPlugins = pkgs.lib.concatMapStringsSep "\n"
    (name: ''ln -sfn ${plugins.${name}} /home/${username}/.config/yazi/plugins/${name}.yazi'')
    (builtins.attrNames plugins);
in
{
  # yazi plugins are file-based runtime plugins, not regular app binaries;
  # we install the plugin packages from nixpkgs, then symlink them into the
  # dotbot-managed ~/.config/yazi tree because yazi loads plugins from there
  environment.systemPackages = with pkgs; [
    yaziPlugins.git
    yaziPlugins.smart-enter
  ];

  # symlink nixpkgs-managed yazi plugins into the dotbot-managed config dir
  # disabled: ~/.config/yazi is symlinked to dotfiles, causing permission issues
  # TODO: migrate to home-manager yazi plugin configuration if needed
  # system.activationScripts.yaziPlugins = ''
  #   ${pkgs.sudo}/bin/sudo -u ${username} bash -c '
  #     mkdir -p /home/${username}/.config/yazi/plugins
  #     ${linkPlugins}
  #   '
  # '';
}
