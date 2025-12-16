{profile, pkgs, ...}: {
  # services to start
  services = {
    libinput.enable = true; # input handling
    fstrim.enable = true; # ssd optimizer
    gvfs.enable = true; # for mounting usb & more
    openssh.enable = true; # enable ssh
    blueman.enable = true; # bluetooth support
    tumbler.enable = true; # image/video preview
    gnome.gnome-keyring.enable = true;
    upower.enable = true; # power management (required for battery monitoring TODO this was required for dms, is it still needed for noctalia?)

    smartd = {
      enable =
        if profile == "vm"
        then false
        else true;
      autodetect = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;  # enable wireplumber session manager
    };
    
    # usb automounting
    udisks2.enable = true;
  };

  # xdg desktop portal for niri (screen sharing, file pickers)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      niri = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      };
    };
  };

  # xwayland satellite service for x11 app support in niri
  systemd.user.services.xwayland-satellite = {
    description = "Xwayland outside Wayland";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  # usb automounter
  systemd.user.services.udiskie = {
    description = "USB automounter";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --tray";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };

}
