#!/usr/bin/env bash
# script called by noctalia colors_change hook
# runs matugen then merges vscode colors

set -e

# previously used wallpaper to generate colors--preserve this for now
# generate colors from wallpaper
# scheme-tonal-spot - balanced, small range of related hues, default
# scheme-expressive - vibrant, unexpected hues, high energy
# scheme-fidelity - literal, match source as closely as possible
# scheme-fruit-salad - playful, highly varied hues, "busy" in a fun way
# scheme-monochrome - greyscale, removes almost all saturation, minimalist
# scheme-neutral - subdued, very low saturation, hint of the source color
# scheme-content - adaptive, dynamically adjusts based on the image
# matugen image "$NOCTALIA_WALLPAPER_PATH" -t scheme-fruit-salad

# ask noctalia for the current theme mode (dark or light) and use that to generate colors
MODE="$(noctalia msg theme-mode-get 2>/dev/null || printf '%s\n' dark)"
COLORS_FILE="$HOME/.config/matugen/schemes/current.json"

# allow non-critical template/post-hook failures to avoid blocking downstream
# updates (e.g., VS Code merge and foot refresh)
matugen json "$COLORS_FILE" -m "$MODE" --continue-on-error || true

# merge colors into vscode settings
~/.config/matugen/merge-vscode-colors.sh
