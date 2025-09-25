{ config, pkgs, mySettings, hostname, bootMode ... }:

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

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  #### networking ####

  networking.hostName = ${hostname};
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
        user = ${mySettings.username};
      };
    };
  };

  #services.printing.enable = true;

  #services.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  #### user accounts ####

  # define a user account (don't forget to set a password with "passwd")
  users.users.${mySettings.username} = {
    isNormalUser = true;
    description = ${mySettings.name};
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    #packages = with pkgs; [];
  };

  #### system packages

  environment.systemPackages = with pkgs; [
    fish
    git
    wayland-utils
    rofi
  ];

  #### programs ####

  programs.hyprland.enable = true;

  #programs.firefox.enable = true;

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
    # Monitor setup
    monitor=,preferred,auto,1

    # Main keyboard and mouse binds
    $mainMod = SUPER

    bind = $mainMod, Q, exec, fish
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, rofi -show drun
    bind = $mainMod, V, togglefloating,

    # Window management
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # Move focus
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # Move windows
    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d
    
    # Workspace switching
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4

    # Move windows to workspaces
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4

    # ... and many more
  '';

}
