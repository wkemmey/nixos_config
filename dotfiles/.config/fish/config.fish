# disable fish greeting
set fish_greeting

# remove this once i'm sure i don't need it
# fix PATH order - ensure wrappers come before system bins
# this works around a nixos fish integration bug where PATH order gets scrambled
# remove all instances of /run/wrappers/bin first, then prepend it
#set -l cleaned_path (string match -v /run/wrappers/bin $PATH)
#set -gx PATH /run/wrappers/bin $cleaned_path

# disable terminal capability query timeout warnings
set -g fish_query_timeout 0

# launch fastfetch on first terminal spawn (only in interactive shells)
if status is-interactive; and not set -q FASTFETCH_LAUNCHED
  set -g FASTFETCH_LAUNCHED 1
  fastfetch
end

# fix a problem where vscode has trouble understanding when fish is finished executing a command
#if status is-interactive
#    if test "$TERM_PROGRAM" = "vscode"
#        # Signal that the command has finished whenever a prompt is about to be shown
#        function vscode_signal_finish --on-event fish_prompt
#            echo -ne "\033]633;D;0\007"
#            echo -ne "\033]633;A\007" # Also signal that a new prompt is starting
#        end
#
#        # Signal that a command is starting
#        function vscode_signal_start --on-event fish_preexec
#            echo -ne "\033]633;B\007"
#        end
#    end
#end

# load personal config if it exists
if test -f $HOME/.fishrc-personal
  source $HOME/.fishrc-personal
end

# initialize starship prompt
starship init fish | source

# initialize zoxide (smart cd)
zoxide init fish --cmd cd | source

# initialize direnv for automatic environment loading
direnv hook fish | source

# browser for cli tools
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

# directory navigation shortcuts
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .3 "cd ../../.."
abbr -a .4 "cd ../../../.."
abbr -a .5 "cd ../../../../.."

# always mkdir with parents
abbr -a mkdir "mkdir -p"

# git abbreviations
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
