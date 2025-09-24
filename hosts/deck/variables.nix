{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "theblackdon";
  gitEmail = "theblackdonatello@gmail.com";

  # Hyprland Settings
  # Configure your monitors here - this is host-specific
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  # You'll need to update this after installation based on your actual monitors
  extraMonitorSettings = ''
    monitor=eDP-1,800x1280@90.0,411x640,1.0
    monitor=eDP-1,transform,3
    monitor=DP-1,2560x1440@60.0,1691x0,1.0
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "vivaldi"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support (update these IDs after hardware detection)
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0";   # Update this with your actual integrated GPU ID
  nvidiaID = "PCI:1:0:0";  # Update this with your actual NVIDIA GPU ID

  # Enable/Disable Features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;
  controllerSupportEnable = true;
  flutterdevEnable = false;
  stylixEnable = true;
  vicinaeEnable = true;
  syncthingEnable = false;

  # Styling
  stylixImage = ../../wallpapers/Valley.jpg;

  # Waybar Choice
  waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;

  # Animation Choice
  animChoice = ../../modules/home/hyprland/animations-end4.nix;
}
