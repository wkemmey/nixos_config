{ pkgs, ... }:

pkgs.writeShellScriptBin "theme-switch" ''
  set -e
  
  # check if argument provided
  if [ $# -eq 0 ]; then
    echo "Usage: theme-switch <wallpaper-path>"
    echo "   or: theme-switch --color <hex-color>"
    echo ""
    echo "Examples:"
    echo "  theme-switch ~/wallpapers/image.png"
    echo "  theme-switch --color \"#cba6f7\"  # catppuccin mocha mauve"
    echo "  theme-switch --color \"#7aa2f7\"  # tokyo night blue"
    exit 1
  fi
  
  # run matugen
  if [ "$1" = "--color" ]; then
    ${pkgs.matugen}/bin/matugen color hex "$2"
  else
    ${pkgs.matugen}/bin/matugen image "$1"
  fi
  
  # reload applications
  echo "Reloading applications..."
  
  # foot terminal
  ${pkgs.killall}/bin/killall -SIGUSR1 foot 2>/dev/null || true
  
  # niri compositor
  niri msg action reload-config 2>/dev/null || true
  
  # fuzzel (will reload on next launch)
  ${pkgs.killall}/bin/pkill -USR1 fuzzel 2>/dev/null || true
  
  echo "Theme applied successfully!"
''
