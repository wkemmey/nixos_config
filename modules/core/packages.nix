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

  # virtualization support for gnome boxes
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # terminal emulators and launchers
    foot # terminal emulator (preferred)
    alacritty # terminal emulator (legacy/default for niri)
    fuzzel # application launcher (default for niri)

    # system monitoring and process management
    bottom # modern system monitor (btop alternative)
    htop # simple terminal based system monitor
    btop # feature-rich system monitor

    # disk usage utilities
    duf # modern disk usage viewer
    dysk # disk usage utility
    gdu # graphical disk usage analyzer
    ncdu # ncurses disk usage analyzer

    # hardware information and control
    brightnessctl # screen brightness control
    inxi # comprehensive system information tool
    lm_sensors # hardware temperature monitoring
    lshw # detailed hardware information
    mesa-demos # gpu info tools (includes glxinfo)
    pciutils # pci device inspection tools
    usbutils # usb device tools

    # file management and archiving
    file-roller # archive manager gui
    unrar # rar archive support
    unzip # zip archive support

    # text editors
    gedit # simple graphical text editor

    # image and graphics
    eog # image viewer
    gimp # advanced photo editor

    # audio and video
    ffmpeg # video/audio encoding and editing
    mpv # versatile video player
    pavucontrol # audio level and device control
    playerctl # media player control through scripts
    sox # audio processing for ffmpeg
    v4l-utils # video4linux utilities (for obs virtual camera)

    # media applications
    obs-studio # video recording and streaming
    picard # music metadata editor and cover art downloader
    youtube-music # youtube music client

    # web browsers
    firefox # mozilla firefox browser

    # networking utilities
    gping # graphical ping tool
    wget # file download tool

    # terminal utilities and tools
    cmatrix # matrix movie effect
    eza # modern ls replacement
    killall # kill all instances of a program
    nitch # minimal fetch utility
    onefetch # git repository information display
    ripgrep # fast grep alternative
    socat # socket utility (needed for screenshots)

    # system utilities
    libnotify # desktop notification support
    tuigreet # login manager (display manager)
    xwayland-satellite # xwayland support outside compositor

    # development tools
    gum # shell script styling and prompts
    popsicle # usb flasher utility

    # nix language tools
    nixfmt-rfc-style # nix code formatter
    nixd # nix language server
    nil # nix language server (alternative)

    # containerization
    docker-compose # docker multi-container management

    # libraries and frameworks
    gtk3 # gtk3 library
    gtk4 # gtk4 library
    pkg-config # package configuration tool

    # file sharing
    localsend # local network file sharing
  ];
}
