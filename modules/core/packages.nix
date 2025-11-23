{
  pkgs,
  lib,
  host,
  ...
}:
{
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # virtualization support (libvirtd for virt-manager, etc.)
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # terminal emulators and launchers
    fuzzel # application launcher (used by niri keybinds, emopicker script)

    # disk usage utilities
    duf # modern disk usage viewer (for user)
    dysk # disk usage utility (for user)
    gdu # graphical disk usage analyzer (for user)
    ncdu # ncurses disk usage analyzer (for user)

    # hardware information and control
    brightnessctl # screen brightness control (for user)
    inxi # comprehensive system information tool (used by dcli script, fastfetch)
    lm_sensors # hardware temperature monitoring (for user)
    lshw # detailed hardware information (for user)
    mesa-demos # gpu info tools (used by inxi/fastfetch for gpu info)
    pciutils # pci device inspection tools (for user)
    usbutils # usb device tools (for user)

    # file management and archiving
    file-roller # archive manager gui (for user)
    unrar # rar archive support (for user)
    unzip # zip archive support (for user)

    # text editors
    gedit # simple graphical text editor (for user)

    # image and graphics
    eog # image viewer (for user)
    gimp # advanced photo editor (for user)

    # audio and video
    ffmpeg # video/audio encoding and editing (for user)
    mpv # versatile video player (for user)
    pavucontrol # audio level and device control (for user)
    playerctl # media player control through scripts (for user)
    sox # audio processing for ffmpeg (dependency for ffmpeg)
    v4l-utils # video4linux utilities (dependency for obs virtual camera)

    # media applications
    picard # music metadata editor and cover art downloader (for user)
    youtube-music # youtube music client (for user)

    # web browsers
    firefox # mozilla firefox browser (for user, set as default in xdg.nix)

    # networking utilities
    gping # graphical ping tool (for user)
    wget # file download tool (for user)

    # terminal utilities and tools
    cmatrix # matrix movie effect (for user)
    killall # kill all instances of a program (for user)
    nitch # minimal fetch utility (for user)
    onefetch # git repository information display (for user)
    ripgrep # fast grep alternative (for user)
    socat # socket utility (used by screenshootin script)

    # system utilities
    libnotify # desktop notification support (used by emopicker9000, niri-gaming-mode, note-from-clipboard scripts)
    tuigreet # login manager (used by greetd.nix as display manager)
    xwayland-satellite # xwayland support outside compositor (used by niri.nix for x11 app support)

    # development tools
    gum # shell script styling and prompts (for user)
    popsicle # usb flasher utility (for user)

    # nix language tools
    nixfmt-rfc-style # nix code formatter (for user)
    nixd # nix language server (for user)
    nil # nix language server (used by evil-helix.nix)

    # rust development tools
    rustup # rust toolchain manager (for user)
    rust-analyzer # rust language server (for user)
    gcc # rust dependency (for user)

    # containerization
    docker-compose # docker multi-container management (for user)

    # libraries and frameworks
    gtk3 # gtk3 library (system dependency for gtk apps)
    gtk4 # gtk4 library (system dependency for gtk apps)
    pkg-config # package configuration tool (build-time dependency for compiling software)

    # file sharing
    localsend # local network file sharing (for user)
  ];
}
