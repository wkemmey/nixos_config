{
  # system configuration
  timeZone = "America/New_York";
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # for nvidia prime support (update if using nvidia-laptop profile)
  # run 'lspci | grep VGA' to find your actual gpu ids
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
  gamingSupportEnable = false;       # gaming controllers, gamescope, protonup-qt
  syncthingEnable = false;           # syncthing file synchronization
  enableCommunicationApps = false;   # discord, teams, zoom, telegram
  enableProductivityApps = true;     # obsidian, quickemu
  aiCodeEditorsEnable = false;       # claude-code, gemini-cli, cursor

  # user info
  userFullName = "Whit Kemmey";

  # startup applications
  startupApps = [];
}
