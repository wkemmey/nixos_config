{
  # the name of this repo; should be in /home/${username}/
  nixosConfigDir = "nixos_config";
  
  # user info
  userFullName = "Whit Kemmey";

  # hardware configuration
  # monitor resolution is used for wallpaper selection
  # need a new plan if we ever have multiple monitors with different resolutions
  monitorResolution = "3840x2160";
  # preferred wallpaper root; if this directory is missing, repo wallpapers are used
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

  # core features
  enableNFS = false;
  enablePrint = true;

  # obsidian vault git backup (systemd timer in modules/core/obsidian.nix)
  # set to the absolute path of the vault to back up to GitHub; leave empty to
  # disable the timer.
  #
  # IMPORTANT: run this on only ONE machine that holds the vault - git is a
  # single-writer backup here, so two machines pushing to the same branch
  # would conflict with each other.
  obsidianVaultDir = "/home/whit/obsidian/whit";

  # optional features (disabled for faster initial install)
  # you can enable these later by setting to true and rebuilding
  enableGamingSupport = true;     # gaming controllers, gamescope, protonup-qt
  enableSyncthing = false;        # syncthing file synchronization
  enableVirtualisation = false;    # docker, libvirtd, virt-manager
}
