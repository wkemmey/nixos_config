#!/usr/bin/env bash
# merge matugen-generated vs code colors into settings.json; this preserves user
# settings while updating color customizations

set -e

SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
COLORS_FILE="$HOME/.config/matugen/vscode-colors.json"

# check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    exit 1
fi

# check if color file exists
if [ ! -f "$COLORS_FILE" ]; then
    echo "Error: Color file not found: $COLORS_FILE" >&2
    exit 1
fi

# create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "{}" > "$SETTINGS_FILE"
fi

# merge colors into settings; this reads the current settings, merges in the
# workbench.colorCustomizations from the colors file, and writes back to settings.json
# use a temp file and only overwrite if jq succeeds (preserves symlinks via cat)
if jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$COLORS_FILE" > "${SETTINGS_FILE}.tmp"; then
    cat "${SETTINGS_FILE}.tmp" > "$SETTINGS_FILE"
    rm "${SETTINGS_FILE}.tmp"
else
    rm -f "${SETTINGS_FILE}.tmp"
    echo "Error: jq failed to merge files" >&2
    exit 1
fi

echo "VS Code colors updated successfully"
