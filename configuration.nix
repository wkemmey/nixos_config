{ config, pkgs, mySettings, hostname, bootMode, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  #### nixos settings ####

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";  # don't change without understanding impacts

  #### boot loader ####

  # if bootMode = uefi
  boot.loader.systemd-boot.enable = bootMode == "uefi";
  boot.loader.efi.canTouchEfiVariables = bootMode == "uefi";

  # if bootMode = bios
  boot.loader.grub.enable = bootMode == "bios";
  boot.loader.grub.device = if bootMode == "bios" then "/dev/sda" else null;
  boot.loader.grub.useOSProber = true;
  
   #### networking ####

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;  # enables wireless support via wpa_supplicant

  # configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # open firewall ports
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # or disable the firewall altogether
  #networking.firewall.enable = false;

  #hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  #### system settings ####

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.caskaydia-mono
  ];

  #### services ####

  services.xserver.enable = false;

  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # enable a display manager for login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        user = "${mySettings.username}";
      };
    };
  };

  #services.printing.enable = true;

  #programs.direnv.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  #### user accounts ####

  # define a user account (don't forget to set a password with "passwd")
  users.users."${mySettings.username}" = {
    isNormalUser = true;
    description = "${mySettings.name}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    #packages = with pkgs; [];
  };

  #### system packages

  environment.systemPackages = with pkgs; [
    git
    wayland-utils
    #rofi-wayland

    # for hyprland
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    #gnome-themes-extra
    pavucntrol

    # for system
    foot
    libnotify
    nautilus
    alejandra
    blueberry
    clipse
    fzf
    zoxide
    ripgrep
    eza
    fd
    curl
    unzip
    wget
    gnumake

    # tuis
    lazygit
    #lazydocker
    btop
    powertop
    fastfetch

    # guis
    chromium
    obsidian
    vlc
    #signal-desktop
    dropbox

    # development tools
    github-desktop
    gh

    # containers
    #docker-compose
    #ffmpeg
    #typora
    
  ];

  #### programs ####

  programs.hyprland.enable = true;

  #programs.firefox.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["${mySettings.username}"];
  };

  # I use zsh btw
  #environment.shells = with pkgs; [ fish ];
  #users.defaultUserShell = pkgs.fish;
  #programs.fish.enable = true;

  #programs.bash = {
  #  promptInit = ''
  #    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
  #  '';
  #};

  # Set up a basic Hyprland configuration
  # This section provides a minimal working config. You should customize it.
  # The configuration is written in the Hyprland format, not Nix.
  environment.etc."hypr/hyprland.conf".text = ''
    # monitor setup
    monitor=,preferred,auto,1

    # main keyboard and mouse binds
    $mainMod = SUPER
    $terminal = kitty
    $browser = chromium
    $fileManager = nautilus
    $music = vlc
    $passwordManager = 1password

    bind = $mainMod, Q, exec, $terminal
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, rofi -show drun
    bind = $mainMod, V, togglefloating,

    # window management
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # move focus
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # move windows
    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d
    
    # workspace switching
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4

    # move windows to workspaces
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4

    # applications
    bind = $mainMod, A, exec, $webapp=https://chatgpt.com"
    bind = $mainMod SHIFT, A, exec, $webapp=https://grok.com"
    bind = $mainMod, C, exec, $webapp=https://app.hey.com/calendar/weeks/"
    bind = $mainMod, E, exec, $webapp=https://app.hey.com"
    bind = $mainMod, Y, exec, $webapp=https://youtube.com/"
    bind = $mainMod SHIFT, G, exec, $webapp=https://web.whatsapp.com/"
    bind = $mainMod, X, exec, $webapp=https://x.com/"
    bind = $mainMod SHIFT, X, exec, $webapp=https://x.com/compose/post"

    bind = $mainMod, return, exec, $terminal"
    bind = $mainMod, F, exec, $fileManager"
    bind = $mainMod, B, exec, $browser"
    bind = $mainMod, M, exec, $music"
    bind = $mainMod, N, exec, $terminal -e nvim"
    bind = $mainMod, T, exec, $terminal -e btop"
    bind = $mainMod, D, exec, $terminal -e lazydocker"
    bind = $mainMod, G, exec, $messenger"
    bind = $mainMod, O, exec, obsidian -disable-gpu"
    bind = $mainMod, slash, exec, $passwordManager"
  '';

}
