# .bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# initialize direnv for automatic environment loading
eval "$(direnv hook bash)"

# source personal bashrc if it exists
[ -f ~/.bashrc-personal ] && source ~/.bashrc-personal
