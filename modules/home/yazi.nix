{ pkgs, ... }: {
  # yazi config (yazi.toml, keymap.toml) is managed by our dotfiles;
  # home-manager only installs yazi and symlinks its plugins into ~/.config/yazi/plugins/
  programs.yazi = {
    enable = true;
    enableFishIntegration = false; # keep shell (cd-on-exit wrapper) managed by dotfiles
    plugins = {
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      lazygit = pkgs.yaziPlugins.lazygit;
    };
  };
}
