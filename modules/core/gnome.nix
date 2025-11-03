{
  pkgs,
  config,
  lib,
  host,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  enableGnome = variables.enableGnome or false;
in
{
  config = lib.mkIf enableGnome {
    # Enable GNOME Desktop Environment
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      # Using SDDM as the display manager instead of GDM
      # SDDM is configured in sddm.nix and will show GNOME as a session option
    };

    # Disable Qt GNOME platform theme to avoid qgnomeplatform build issues
    # Qt apps will use default theming instead
    qt.enable = lib.mkForce false;
    qt.platformTheme = lib.mkForce null;

    # Essential GNOME services
    services.gnome = {
      core-utilities.enable = true;
      gnome-keyring.enable = true;
    };

    # Exclude unnecessary GNOME packages for homelab use
    environment.gnome.excludePackages = with pkgs; [
      epiphany # GNOME Web browser (user will use zen/firefox)
      geary # Email client
      gnome-music
      gnome-photos
      gnome-contacts
      gnome-maps
      totem # Video player
      yelp # Help viewer
      gnome-software
      gnome-calendar
      gnome-weather
      simple-scan
      cheese # Webcam app
    ];

    # Enable dconf for GNOME settings
    programs.dconf.enable = true;

    # Add essential system packages for GNOME
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ];
  };
}
