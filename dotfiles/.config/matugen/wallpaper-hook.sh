#!/usr/bin/env bash
# wrapper script called by noctalia wallpaper change hook
# runs matugen then merges vscode colors

#set -e

# log execution for debugging
echo "[$(date)] wallpaper-hook.sh called" >> /tmp/wallpaper-hook.log
echo "  \$1 = '$1'" >> /tmp/wallpaper-hook.log

# generate colors from wallpaper
matugen image "$1"

# merge colors into vscode settings
~/.config/matugen/merge-vscode-colors.sh
