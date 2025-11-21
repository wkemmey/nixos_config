{
  config,
  pkgs,
  lib,
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

    shellAliases = {
      # system aliases
      c = "clear";

      # nixos aliases
      fr = "dcli rebuild";
      fu = "dcli update";
      rebuild = "dcli rebuild";
      update = "dcli update";
      cleanup = "dcli cleanup";
      hosts = "dcli list-hosts";
      switchhost = "dcli switch-host"; # 'switch' is reserved in fish

      nxr = "cd $HOME/nixos_config"

      # git aliases
      gs = "git status";
      gl = "git log";
      ga = "git add *";
      gc = "git commit -m 'Update'"'
      gp = "git push";

      # NixOS specific
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";

      # Better defaults
      cat = "bat";
      man = "batman";

      # Additional eza aliases (base ones are in eza.nix)
      ld = "eza -lhD --icons=auto"; # list directories only

      # Directory navigation shortcuts
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";

      # Always mkdir with parents
      mkdir = "mkdir -p";
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
# single key
abbr -a -- c clear
abbr -a -- h history
abbr -a -- l 'ls -UF'

# better ls
abbr -a -- la 'ls -lah'
abbr -a -- ldot 'ls -ld .*'
abbr -a -- ll 'ls -lGFh'
abbr -a -- lsa 'ls -aGF'

# quick nav
abbr -a -- fconf 'cd $__fish_config_dir'
abbr -a -- fishconf 'cd $__fish_config_dir'
abbr -a -- fdot 'cd $__fish_config_dir'
abbr -a -- zdot 'cd $ZDOTDIR'

# date/time
abbr -a -- ds 'date +%Y-%m-%d'
abbr -a -- ts 'date +%Y-%m-%dT%H:%M:%SZ'
abbr -a -- yyyymmdd 'date +%Y%m%d'

# git
# abbr -a -- gad 'git add'
# abbr -a -- gbn 'git rev-parse --abbrev-ref HEAD'
# abbr -a -- gcl 'git clean'
# abbr -a -- gcmt 'git commit -am '
# abbr -a -- gco 'git checkout'
# abbr -a -- gcob 'git checkout -b '
# abbr -a -- gcod 'git checkout develop'
# abbr -a -- gcom 'git checkout master'
# abbr -a -- get git
# abbr -a -- glg 'git log'
# abbr -a -- glog git\ log\ --Uraph\ --pretty=\'\%Cred\%h\%Creset\ -\%C\(auto\)\%d\%Creset\ \%s\ \%Cgreen\(\%ad\)\ \%C\(bold\ blue\)\<\%an\>\%Creset\'\ --date=short
# abbr -a -- gpll 'git pull'
# abbr -a -- gpristine 'git reset --hard && git clean -fdx'
# abbr -a -- gpsh 'git push'
# abbr -a -- gpsuo 'git push --set-Upstream origin (git rev-parse --abbrev-ref HEAD)'
# abbr -a -- grm 'git rm'
# abbr -a -- grv 'git remote -v'
# abbr -a -- gsh 'git stash'
# abbr -a -- gst 'git status -sb'
abbr -a -- gclone 'git clone git@github.com:mattmc3/'
abbr -a -- gwhoami 'echo "user.name:" (git config user.name) && echo "user.email:" (git config user.email)'



https://nixos.wiki/wiki/Fish