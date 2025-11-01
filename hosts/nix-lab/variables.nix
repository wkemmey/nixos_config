{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "theblackdon";
  gitEmail = "theblackdonatello@gmail.com";

  # Hyprland Settings
  # Steam Deck display configuration
  # The Steam Deck has a 1280x800 display at 60Hz
  extraMonitorSettings = ''
    monitor=,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "zen"; # Set Default Browser
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # Steam Deck uses AMD APU - these IDs are not used
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Enable/Disable Features
  enableNFS = false; # Disabled for portable gaming device
  printEnable = false; # Disabled for portable gaming device
  thunarEnable = true;
  controllerSupportEnable = true; # Enable Controller Support For Gaming
  flutterdevEnable = false; # Enable Flutter Development Environment
  stylixEnable = true; # Enable Stylix System Theming
  syncthingEnable = true; # Enable Syncthing File Synchronization

  # Window Manager Choice
  windowManager = "hyprland"; # Options: "niri" or "hyprland"

  # Bar/Shell Choice
  barChoice = "waybar"; # Options: "dms", "noctalia", or "waybar"

  # Shell Choice
  defaultShell = "zsh"; # Options: "fish" or "zsh"

  # Styling
  stylixImage = ../../wallpapers/marvel-gambit.jpg;

  # Waybar Choice
  waybarChoice = ../../modules/home/waybar/jak-catppuccin.nix;

  # Animation Choice
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Startup Applications
  startupApps = [
  ];

  # Steam Deck Specific Settings
  steamDeckMode = true; # Flag to enable Steam Deck optimizations
}
