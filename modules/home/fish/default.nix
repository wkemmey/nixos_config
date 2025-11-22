{
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  accent = "#${config.lib.stylix.colors.base0D}";
in
{
  programs.fish = {
    enable = true;

    # disable fish greeting
    interactiveShellInit = ''
      set fish_greeting

      # launch fastfetch on first terminal spawn
      if not set -q FASTFETCH_LAUNCHED
        set -gx FASTFETCH_LAUNCHED 1
        fastfetch
      end

      # load personal config if it exists
      if test -f $HOME/.fishrc-personal
        source $HOME/.fishrc-personal
      end
    '';

    # shell initialization for PATH additions
    shellInit = ''
      # add local bin directories to PATH
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.pub-cache/bin
    '';

    #functions = {
    #};

    # fish abbreviations (expanded when pressing space or enter)
    shellAbbrs = {
      # single key shortcuts
      c = "clear";
      h = "history";

      # nixos abbreviations
      nxr = "nixos-rebuild switch --flake .#${host}";
      nxu = "nix flake update";
      nxg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      nxcd = "cd ~/black-don-os";

      # better defaults
      cat = "bat";
      man = "batman";

      # Directory navigation shortcuts
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";

      # Always mkdir with parents
      mkdir = "mkdir -p";

      # Git abbreviations
      ga = "git add *";
      gbn = "git rev-parse --abbrev-ref HEAD";
      gcl = "git clean";
      gc = "git commit -am";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcod = "git checkout develop";
      gcom = "git checkout master";
      gl = "git log";
      glog = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
      gpl = "git pull";
      gpristine = "git reset --hard && git clean -fdx";
      gp = "git push";
      gpsuo = "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)";
      grm = "git rm";
      grv = "git remote -v";
      gstash = "git stash";
      gs = "git status -sb";
      gwhoami = "echo \"user.name:\" (git config user.name) && echo \"user.email:\" (git config user.email)";
    };

    # Fish plugins for enhanced functionality
    plugins = [
      # FZF integration for Fish
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      # Auto-complete matching pairs
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      # Notifications when long commands finish
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      # Clean failed commands from history
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
  };
}
