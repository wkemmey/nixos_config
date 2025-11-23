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

  # Virtualization support for GNOME Boxes
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bottom # btop like util
    brightnessctl # For Screen Brightness Control
    cmatrix # Matrix Movie Effect In Terminal
    cowsay # Great Fun Terminal Program
    docker-compose # Allows Controlling Docker From A Single File
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # disk usage util
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    file-roller # Archive Manager
    gdu # graphical disk usage
    gedit # Simple Graphical Text Editor
    gimp # Great Photo Editor
    mesa-demos # Needed for inxi -G GPU info (includes glxinfo)
    gping # graphical ping
    tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    htop # Simple Terminal Based System Monitor
    eog # For Image Viewing
    # Terminal emulators
    foot # terminal emulator (preferred)
    alacritty # Terminal Emulator (legacy/default for niri)
    fuzzel # Application Launcher (default for niri)
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nitch # small fetch util
    # Nix Language Packages
    nixfmt-rfc-style # Nix Formatter
    nixd # Nix Language Server
    nil # Nix Language Server
    onefetch # shows current build info and stats
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    picard # For Changing Music Metadata & Getting Cover Art
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    ripgrep # Improved Grep
    socat # Needed For Screenshots
    sox # audio support for FFMPEG
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    v4l-utils # Used For Things Like OBS Virtual Camera
    obs-studio # OBS Studio (system package)
    wget # Tool For Fetching Files With Links
    xwayland-satellite # Xwayland outside your Wayland compositor
    nwg-displays # Manage Displays
    nwg-drawer # drawer GUI
    nwg-look # Look GUI
    youtube-music
    firefox
    # Development Tools
    popsicle
    # AI code editors (cursor, claude-code, gemini-cli) moved to modules/core/ai-code-editors.nix
    gum
    gtk3
    gtk4
    localsend
  ];
}
