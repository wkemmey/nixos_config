{ config, pkgs, host, username, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  monitorResolution = variables.monitorResolution or "3840x2160";
  preferredWallpaperDirectory = variables.wallpaperDirectory or "";
in {
  # install dotbot for dotfiles management
  environment.systemPackages = with pkgs; [
    dotbot
  ];

  # run dotbot on system activation to create symlinks
  system.activationScripts.dotbot = ''
    if [ -n "${preferredWallpaperDirectory}" ] && [ -d "${preferredWallpaperDirectory}" ]; then
      WALLPAPER_ROOT="${preferredWallpaperDirectory}"
    else
      WALLPAPER_ROOT="/home/${username}/nixos_config/wallpapers"
    fi

    # run dotbot as the user to create symlinks in home directory
    ${pkgs.sudo}/bin/sudo -u ${username} \
      env MONITOR_RESOLUTION="${monitorResolution}" WALLPAPER_ROOT="$WALLPAPER_ROOT" \
      ${pkgs.dotbot}/bin/dotbot \
      -d /home/${username}/nixos_config/dotfiles \
      -c /home/${username}/nixos_config/dotfiles/install.conf.yaml
  '';
}
