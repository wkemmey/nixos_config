{ config, pkgs, unstablePkgs, lib, mySettings, hostname, bootMode, ... }:

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
  boot.loader.grub.useOSProber = bootMode == "bios";
  
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
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

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
    rofi-wayland

    # for hyprland
    # for hyprland (using unstable where needed)
    #unstablePkgs.hyprshot # FIX: Moved to unstable
    #unstablePkgs.hyprpicker # FIX: Moved to unstable
    # hyprsunset (still commented out, but would use unstablePkgs.hyprsunset)
    #unstablePkgs.brightnessctl # FIX: Moved to unstable
    #unstablePkgs.pamixer # FIX: Moved to unstable
    #unstablePkgs.playerctl # FIX: Moved to unstable
    # pavucntrol (still commented out)

#You may also be interested in the Hypr project's collection of tools:

#hyprlock: Hyprland's GPU-accelerated screen locking utility.
#hypridle: Hyprland's idle daemon.
#hyprpaper: Hyprland's wallpaper utility.
#hyprsunset: Application to enable a blue-light filter on Hyprland.
#hyprpicker: Wayland color picker that does not suck.
#hyprpolkitagent: Polkit authentication agent written in QT/QML.


    # for system
    foot
    #libnotify
    nautilus
    #alejandra
    #blueberry
    #clipse
    ##fzf
    ##zoxide
    #ripgrep
    ##eza
    ##fd
    curl
    unzip
    wget
    gnumake

    # tuis
    #lazygit
    #lazydocker
    btop
    powertop
    #fastfetch

    # guis
    chromium
    obsidian
    vlc
    #signal-desktop
    dropbox
    #onepassword-cli 
    #onepassword-gui

    # development tools
    github-desktop
    gh # official github cli

    # containers
    #docker-compose
    #ffmpeg
    #typora
    
  ];

  #### programs ####

  #programs.hyprland.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    #xwayland.enable = true; # Xwayland can be disabled.
  };

  #programs.firefox.enable = true;

  #programs._1password.enable = true;
  #programs._1password-gui = {
  #  enable = true;
  #  polkitPolicyOwners = ["${mySettings.username}"];
  #};

  # I use zsh btw
  #environment.shells = with pkgs; [ fish ];
  #users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  #programs.bash = {
  #  promptInit = ''
  #    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
  #  '';
  #};

}
