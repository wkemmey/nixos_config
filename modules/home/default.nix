{ pkgs, inputs, host, lib, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) monitorResolution;
in
{
  imports = [
    ./virtmanager.nix
    ./vscode.nix
    ./obs-studio.nix
    ./scripts
  ];

  # initialize matugen.kdl if missing to prevent niri from breaking
  home.activation.initMatugen = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD [ -f ~/.config/niri/matugen.kdl ] || ${pkgs.matugen}/bin/matugen color hex '#808080'
  '';

  # update wallpaper resolution symlink based on configured monitor resolution
  home.activation.updateWallpaperResolution = lib.hm.dag.entryAfter ["writeBoundary"] ''
    WALLPAPER_DIR="$HOME/nixos_config/wallpapers"
    SYMLINK="$WALLPAPER_DIR/current_resolution"
    RESOLUTION="${monitorResolution}"
    TARGET_DIR="$WALLPAPER_DIR/$RESOLUTION"
    
    $DRY_RUN_CMD rm -f "$SYMLINK"
    $DRY_RUN_CMD ln -sf "$RESOLUTION" "$SYMLINK"
    echo "Wallpaper resolution symlink updated to: $RESOLUTION"
  '';
}
