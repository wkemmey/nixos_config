{ config, pkgs, ... }:
let
  browser = "${pkgs.google-chrome}/bin/google-chrome-stable";

  # Build a desktop entry for a web app (PWA) launched in Chrome's app mode.
  #
  # - --app:           standalone window (no tabs/address bar)
  # - --user-data-dir: isolated profile (own cookies/session; log in once per app)
  # - --class + StartupWMClass: let niri and the launcher match the window to the app
  #
  # Icons are PNGs from https://github.com/walkxcode/dashboard-icons
  # (raw files at https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/<name>.png).
  # To add an app, drop its PNG into ./webapp-icons/ and add an entry below.
  webapp = { name, url, icon, wmClass, categories }:
    {
      inherit name;
      exec = "${browser} --app=${url} --user-data-dir=${config.home.homeDirectory}/.local/share/webapp/${wmClass} --class=${wmClass}";
      icon = toString icon;
      terminal = false;
      categories = categories;
      settings.StartupWMClass = wmClass;
    };
in
{
  xdg.desktopEntries = {
    youtube-music = webapp {
      name = "YouTube Music";
      url = "https://music.youtube.com";
      icon = ./webapp-icons/youtube-music.png;
      wmClass = "YouTubeMusic";
      categories = [ "Audio" "AudioVideo" ];
    };

    discord = webapp {
      name = "Discord";
      url = "https://discord.com/app";
      icon = ./webapp-icons/discord.png;
      wmClass = "Discord";
      categories = [ "Utility" ];
    };
  };
}
