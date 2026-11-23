{ ... }: {
  programs.niri.enable = true;

  # niri-specific portal config: screen sharing through the gnome portal
  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
  };
}
