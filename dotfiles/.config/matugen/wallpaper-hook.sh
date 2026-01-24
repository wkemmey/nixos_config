#!/usr/bin/env bash
# wrapper script called by noctalia wallpaper change hook
# runs matugen then merges vscode colors

set -e

# generate colors from wallpaper
# scheme-tonal-spot - balanced, small range of related hues, default
# scheme-expressive - vibrant, unexpected hues, high energy
# scheme-fidelity - literal, match source as closely as possible
# scheme-fruit-salad - playful, highly varied hues, "busy" in a fun way
# scheme-monochrome - greyscale, removes almost all saturation, minimalist
# scheme-neutral - subdued, very low saturation, hint of the source color
# scheme-content - adaptive, dynamically adjusts based on the image
matugen image "$1" -t scheme-fruit-salad

# merge colors into vscode settings
~/.config/matugen/merge-vscode-colors.sh
