{
  # the name of this repo; should be in /home/${username}/
  nixosConfigDir = "nixos_config";
  
  # user info
  userFullName = "Whit Kemmey";

  # monitor resolution is used for wallpaper selection
  # need a new plan if we ever have multiple monitors with different resolutions
  monitorResolution = "3840x2160";

  # preferred wallpaper root; if this directory is missing or "", default wallpapers are used
  wallpaperDirectory = "/home/whit/Dropbox/computers/wallpaper";

  # for nvidia prime support (update if using nvidia-laptop profile; unused otherwise)
  # run 'lspci | grep VGA' to find your actual gpu ids
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # system configuration
  timeZone = "America/New_York";
  consoleKeyMap = "us";

  # default applications
  defaultShell = "fish";

  # obsidian vault git backup (systemd timer in modules/core/obsidian.nix)
  # set to the absolute path of the vault to back up to GitHub; leave empty to
  # disable the timer.
  #
  # IMPORTANT: run this on only ONE machine that holds the vault - git is a
  # single-writer backup here, so two machines pushing to the same branch
  # would conflict with each other.
  obsidianVaultDir = "/home/whit/obsidian/whit";

  # optional features
  enableNFS = false;
  enablePrint = true;
  enableGamingSupport = true;     # gaming controllers, gamescope, protonup-qt
  enableSyncthing = false;        # syncthing file synchronization
  enableVirtualisation = false;   # docker, libvirtd, virt-manager
  
  # weekly print-head maintenance (systemd timer in modules/core/print-test.nix)
  # prints a full-color test page once a week to keep inkjet heads from drying.
  # run on only ONE machine that has the printer (requires enablePrint = true).
  enablePrintMaintenance = true;  # weekly print test page (keep heads from drying)
}
