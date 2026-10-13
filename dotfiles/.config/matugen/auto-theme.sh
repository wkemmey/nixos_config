#!/usr/bin/env bash
# find current wallpaper and run matugen
# this works around noctalia not passing $WALL to hooks

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
MERGE_SCRIPT="$SCRIPT_DIR/merge-vscode-colors.sh"

# Prefer repo-relative wallpapers when this script is symlinked from the repo.
REPO_WALLPAPER_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)/wallpapers"
if [ -d "$REPO_WALLPAPER_DIR" ]; then
    WALLPAPER_DIR="$REPO_WALLPAPER_DIR"
else
    WALLPAPER_DIR="$HOME/${NIXOS_CONFIG_DIR:-nixos_config}/wallpapers"
fi

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "[$(date)] Wallpaper directory not found: $WALLPAPER_DIR" >> /tmp/wallpaper-auto.log
    exit 0
fi

# get the most recently accessed image file (noctalia reads it when setting)
CURRENT_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf '%A@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)

if [ -n "$CURRENT_WALL" ]; then
    echo "[$(date)] Running matugen with: $CURRENT_WALL" >> /tmp/wallpaper-auto.log
    matugen image "$CURRENT_WALL"
    if [ -x "$MERGE_SCRIPT" ]; then
        "$MERGE_SCRIPT"
    fi
else
    echo "[$(date)] No wallpaper found" >> /tmp/wallpaper-auto.log
fi
