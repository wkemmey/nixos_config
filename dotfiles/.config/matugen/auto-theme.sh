#!/usr/bin/env bash
# find current wallpaper and run matugen
# this works around noctalia not passing $WALL to hooks

WALLPAPER_DIR="/home/whit/nixos_config/wallpapers"

# get the most recently accessed image file (noctalia reads it when setting)
CURRENT_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf '%A@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)

if [ -n "$CURRENT_WALL" ]; then
    echo "[$(date)] Running matugen with: $CURRENT_WALL" >> /tmp/wallpaper-auto.log
    matugen image "$CURRENT_WALL"
    /home/whit/.config/matugen/merge-vscode-colors.sh
else
    echo "[$(date)] No wallpaper found" >> /tmp/wallpaper-auto.log
fi
