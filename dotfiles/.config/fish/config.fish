# disable fish greeting
set fish_greeting

# launch fastfetch on first terminal spawn
if not set -q FASTFETCH_LAUNCHED
  set -g FASTFETCH_LAUNCHED 1
  fastfetch
else
  echo "DEBUG: FASTFETCH_LAUNCHED already set to: $FASTFETCH_LAUNCHED"
end

# load personal config if it exists
if test -f $HOME/.fishrc-personal
  source $HOME/.fishrc-personal
end

# initialize starship prompt
starship init fish | source

# add local bin directories to PATH
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.pub-cache/bin

# browser for CLI tools
set -gx BROWSER "xdg-open"

# bat/man configuration
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

# eza configuration
set -gx EZA_ICONS_AUTO 1
set -gx EZA_GRID_ROWS 1

# eza aliases
alias ls 'eza --group-directories-first --git-ignore --icons=always --classify --hyperlink'
alias lt 'eza --tree --level=2'
alias ll 'eza -lh --no-user --long --header --group-directories-first --git --icons=always'
alias la 'eza -lah --group-directories-first --git --icons=always'
alias ld 'eza -lhD --icons=auto'
alias ldot 'eza -lhd .*'
alias tree 'eza --tree'

# fish abbreviations (expanded when pressing space or enter)
# single key shortcuts
abbr -a c clear
abbr -a h history

# nixos abbreviations
abbr -a nxr "sudo nixos-rebuild switch --flake .#(hostname)"
abbr -a nxu "nix flake update"
abbr -a nxg "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot"
abbr -a nxcd "cd ~/nixos_config"

# better defaults
abbr -a cat bat
abbr -a man batman

# Directory navigation shortcuts
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .3 "cd ../../.."
abbr -a .4 "cd ../../../.."
abbr -a .5 "cd ../../../../.."

# Always mkdir with parents
abbr -a mkdir "mkdir -p"

# Git abbreviations
abbr -a ga "git add *"
abbr -a gbn "git rev-parse --abbrev-ref HEAD"
abbr -a gcl "git clean"
abbr -a gc "git commit -am"
abbr -a gd "git diff"
abbr -a gco "git checkout"
abbr -a gcob "git checkout -b"
abbr -a gcod "git checkout develop"
abbr -a gcom "git checkout master"
abbr -a gl "git log"
abbr -a glog "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
abbr -a gpl "git pull"
abbr -a gpristine "git reset --hard && git clean -fdx"
abbr -a gp "git push"
abbr -a gpsuo "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)"
abbr -a grm "git rm"
abbr -a grv "git remote -v"
abbr -a gstash "git stash"
abbr -a gs "git status -sb"
abbr -a gwhoami "echo \"user.name:\" (git config user.name) && echo \"user.email:\" (git config user.email)"
