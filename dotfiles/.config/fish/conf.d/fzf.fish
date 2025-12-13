# fzf configuration for fish shell

# fzf colors (catppuccin-inspired)
set -gx FZF_DEFAULT_OPTS "--color=fg:#cdd6f4,bg:-1,fg+:#89b4fa,bg+:-1,prompt:#585b70,pointer:#89b4fa \
--margin=1 \
--layout=reverse \
--border=none \
--info=hidden \
--header= \
--prompt='--> ' \
-i \
--no-bold \
--bind=enter:execute(nvim {}) \
--preview='bat --style=numbers --color=always --line-range :500 {}' \
--preview-window=right:60%:wrap"

# initialize fzf key bindings for fish
fzf --fish | source
