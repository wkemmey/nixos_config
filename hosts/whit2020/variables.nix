{
  # system configuration
  timeZone = "America/New_York";
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # for Nvidia Prime support (update if using nvidia-laptop profile)
  # run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # default applications
  browser = "firefox";
  terminal = "foot";
  defaultShell = "fish";

  # core features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;

  # optional features (disabled for faster initial install)
  # you can enable these later by setting to true and rebuilding
  gamingSupportEnable = false;       # Gaming controllers, gamescope, protonup-qt
  syncthingEnable = false;           # Syncthing file synchronization
  enableCommunicationApps = false;   # Discord, Teams, Zoom, Telegram
  enableProductivityApps = true;     # Obsidian, QuickEmu
  aiCodeEditorsEnable = false;       # Claude-code, gemini-cli, cursor

  # desktop environment
  barChoice = "noctalia"; 

  # theming
  wallpaperImage = ../../wallpapers/3840x2160_bonsai_rock_milky.jpg;
  colorScheme = "catppuccin-mocha";

  # git configuration
  gitUsername = "whit";
  gitEmail = "whit@fastmail.com";

  # startup applications
  startupApps = [];
}
