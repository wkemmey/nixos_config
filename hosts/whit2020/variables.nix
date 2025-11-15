{
  # Git Configuration
  gitUsername = "whit";
  gitEmail = "whit@fastmail.com";

  # System Configuration
  timeZone = "America/New_York";

  # Monitor Settings (update after installation for your displays)
  extraMonitorSettings = ''
    monitor=,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = false;

  # Default Applications
  browser = "firefox";
  terminal = "foot";
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support (update if using nvidia-laptop profile)
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Core Features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;
  stylixEnable = true;

  # Optional Features (disabled for faster initial install)
  # You can enable these later by setting to true and rebuilding
  gamingSupportEnable = false;       # Gaming controllers, gamescope, protonup-qt
  flutterdevEnable = false;          # Flutter development environment
  syncthingEnable = false;           # Syncthing file synchronization
  enableCommunicationApps = false;   # Discord, Teams, Zoom, Telegram
  enableExtraBrowsers = false;       # Vivaldi, Brave, Firefox, Chromium, Helium
  enableProductivityApps = true;    # Obsidian, GNOME Boxes, QuickEmu
  aiCodeEditorsEnable = false;       # Claude-code, gemini-cli, cursor

  # Desktop Environment
  enableHyprlock = false;  # Set to false if using Noctalia lock screens

  # Bar/Shell Choice
  barChoice = "noctalia";      # Options: "noctalia"

  # Shell Choice
  defaultShell = "fish";   # Options: "fish" or "zsh"

  # Theming
  stylixImage = ../../wallpapers/3840x2160_aenami_timeless.png;
  # Color scheme: prefer Stylix-controlled schemes (e.g. "darktooth" or "catppuccin-mocha")
  colorScheme = "catppuccin-mocha";
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;  # Waybar temporarily disabled
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Startup Applications
  startupApps = [];
}
