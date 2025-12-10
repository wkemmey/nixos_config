# Eza aliases (ls replacement)
# https://github.com/eza-community/eza

# Basic aliases
alias ls='eza'
alias lt='eza --tree --level=2'
alias ll='eza -lh --no-user --long'
alias la='eza -lah'
alias ld='eza -lhD --icons=auto'  # list directories only
alias ldot='eza -lhd .*'  # list dotfiles/directories
alias tree='eza --tree'

# Eza default options (set as environment variable)
export EZA_ICONS_AUTO=1
export EZA_GRID_ROWS=1
