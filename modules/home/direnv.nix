{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    # disable shell integration since we manage hooks in dotfiles
    enableBashIntegration = false;
    enableFishIntegration = false;
    
    # source devenv's direnvrc globally; version syncs with installed devenv package
    stdlib = ''
      source <(devenv direnvrc)
    '';
  };
}
