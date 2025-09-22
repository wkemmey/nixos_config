{ config, pkgs, ... }:

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

  networking.hostName = "nixos";  # NOTE: host name must match here and flake.nix
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

  #services.xserver.enable = true;

  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
  users.users.whit = {
    isNormalUser = true;
    description = "Whit Kemmey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  #### system packages

  environment.systemPackages = with pkgs; [
    ghostty
    git
  ];

  #### programs ####

  #programs.firefox.enable = true;

  programs.bash = {
    promptInit = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
    '';
  };

}
