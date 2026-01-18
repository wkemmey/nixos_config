{ pkgs, ... }:

pkgs.writeShellScriptBin "theme-switch" ''
  set -e
  
  # Check if argument provided
  if [ $# -eq 0 ]; then
    echo "Usage: theme-switch <wallpaper-path>"
    echo "   or: theme-switch --scheme <scheme-name>"
    echo ""
    echo "Available schemes: catppuccin-mocha, tokyo-night, nord, gruvbox-dark"
    exit 1
  fi
  
  # Run matugen
  if [ "$1" = "--scheme" ]; then
    ${pkgs.matugen}/bin/matugen scheme "$2"
  else
    ${pkgs.matugen}/bin/matugen image "$1"
  fi
  
  # Reload applications
  echo "Reloading applications..."
  
  # Foot terminal
  ${pkgs.killall}/bin/killall -SIGUSR1 foot 2>/dev/null || true
  
  # Niri compositor
  niri msg action reload-config 2>/dev/null || true
  
  # Fuzzel (will reload on next launch)
  ${pkgs.killall}/bin/pkill -USR1 fuzzel 2>/dev/null || true
  
  echo "Theme applied successfully!"
''
