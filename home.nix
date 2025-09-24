{ config, pkgs, ... }:

{
  # ... all your other stuff

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      .. = "cd ..";
    };
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      .. = "cd ..";
    };
  };

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "youremail@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
      safe.directory = "/home/yourusername/.dotfiles";
    };
  };

}