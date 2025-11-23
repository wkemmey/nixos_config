{
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) stylixEnable colorScheme;
in
lib.mkIf stylixEnable {
  stylix = {
    #useWallpaperColors = false;
    # Targets control which application-specific outputs Stylix will produce.
    # Enable common targets for terminals, editors and toolkits so Stylix can
    # generate matching configs (where supported).
    targets = {
      qt.enable = true;
      gtk.enable = true;
      # Terminal emulators
      foot.enable = true;
      alacritty.enable = true;
      # Editor / browser
      vscode.enable = true;
      firefox.enable = true;
    };
  };

  services.nwg-drawer-stylix.enable = true;
}
