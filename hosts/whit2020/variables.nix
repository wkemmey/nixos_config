{
  # user info
  userFullName = "Whit Kemmey";

  # hardware configuration
  # monitor resolution is used for wallpaper selection
  # need a new plan if we ever have multiple monitors with different resolutions
  monitorResolution = "3840x2160";
  # for nvidia prime support (update if using nvidia-laptop profile; unused otherwise)
  # run 'lspci | grep VGA' to find your actual gpu ids
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # system configuration
  timeZone = "America/New_York";
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # default applications
  defaultShell = "fish";

  # core features
  enableNFS = false;
  enablePrint = true;
  enableThunar = true;

  # optional features (disabled for faster initial install)
  # you can enable these later by setting to true and rebuilding
  enableGamingSupport = true;        # gaming controllers, gamescope, protonup-qt
  enableSyncthing = false;           # syncthing file synchronization
  enableCommunicationApps = false;   # discord, teams, zoom, telegram
  enableProductivityApps = true;     # obsidian, quickemu
  enableAiCodeEditors = false;       # claude-code, gemini-cli, cursor
}
