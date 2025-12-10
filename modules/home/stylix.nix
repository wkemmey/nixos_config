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
      gtk.enable = false; # managed via dotfiles
      # Terminal emulators
      foot.enable = false; # managed via dotfiles
      alacritty.enable = false;
      # Editor / browser
      vscode.enable = false; # managed via dotfiles
      firefox.enable = true;
    };
  };
}
