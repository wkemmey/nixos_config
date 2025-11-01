{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "theblackdon";
  gitEmail = "theblackdonatello@gmail.com";

  # Hyprland Settings
  # Configure your monitors here - this is host-specific
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  # You'll need to update this after installation based on your actual monitors
  extraMonitorSettings = ''
    monitor=DP-1,3440x1440@180.0,2740x1455,1.0
    monitor=DP-2,1920x1080@60.0,820x1714,1.0
    monitor=DP-3,1920x1080@60.0,6180x1714,1.0
    workspace=1,monitor:DP-1
    workspace=2,monitor:DP-2
    workspace=3,monitor:DP-3
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "zen"; # Set Default Browser
  terminal = "kitty"; # Set Default System Terminal
  defaultShell = "zsh"; # Set Default Shell
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support (update these IDs after hardware detection)
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0"; # Update this with your actual integrated GPU ID
  nvidiaID = "PCI:1:0:0"; # Update this with your actual NVIDIA GPU ID

  # Enable/Disable Features
  enableNFS = true;
  printEnable = false;
  thunarEnable = true;
  controllerSupportEnable = true;
  flutterdevEnable = true;
  syncthingEnable = false;
  davinciResolveEnable = true;

  # Window Manager Choice
  windowManager = "niri"; # Options: "niri" or "hyprland"

  # Enable Stylix System Theming
  stylixEnable = true;
  # Set Stylix Image
  stylixImage = ../../wallpapers/gambit-sorcerer-rl.jpg;

  # Bar/Shell Choice
  barChoice = "dms"; # Options: "dms", "noctalia", or "waybar"

  # Waybar Theme (used when barChoice = "waybar")
  waybarChoice = ../../modules/home/waybar/waybar-jerry.nix;

  # Animation Choice
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Startup Applications
  startupApps = [
  ];
}
