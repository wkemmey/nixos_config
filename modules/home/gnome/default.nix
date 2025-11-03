{
  pkgs,
  lib,
  config,
  ...
}:
{
  # GNOME Desktop Environment
  # Minimal configuration for homelab/server use

  home.packages = with pkgs; [
    # Essential GNOME apps
    gnome-console # GNOME terminal
    gnome-text-editor
    nautilus # File manager
    gnome-calculator
    gnome-system-monitor

    # GNOME utilities
    gnome-tweaks
    dconf-editor

    # Extensions support
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
  ];

  # GNOME Terminal (Console) configuration
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    # Enable extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
  };
}
