{ config, pkgs, mySettings, ... }:

{
  # Set the home directory and state directory
  home.username = "whit"; #"${mySettings.username}";
  home.homeDirectory = "/home/whit"; #"/home/${mySettings.username}";
  home.stateVersion = "25.05"; # Match your NixOS state version
  
  #programs.bash = {
  #  enable = true;
  #  shellAliases = {
  #    ll = "ls -l";
  #    .. = "cd ..";
  #  };
  #};
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      #.. = "cd ..";
    };
  };

  programs.git = {
    enable = true;
    userName = "${mySettings.name}";
    userEmail = "${mySettings.email}";
    extraConfig = {
      init.defaultBranch = "main";
      #safe.directory = [ "/etc/nixos" "${mySettings.dotfilesDir}" ];
      safe.directory = [ "/etc/nixos" "~/.dotfiles" ];
    };
  };

}