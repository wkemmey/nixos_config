{ config, pkgs, host, username, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  monitorResolution = variables.monitorResolution or "3840x2160";
  preferredWallpaperDirectory = variables.wallpaperDirectory or "";
  nixosConfigDir = variables.nixosConfigDir or "nixos_config";
in {
  # install dotbot for dotfiles management
  environment.systemPackages = with pkgs; [
    dotbot
  ];

  # run dotbot after normal boot as the target user (works on fresh installs)
  systemd.services.dotbot-link = {
    description = "Apply dotfiles symlinks with Dotbot";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" "systemd-user-sessions.service" ];
    before = [ "greetd.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = username;
      Group = "users";
      RemainAfterExit = true;
    };

    script = ''
      set -eu

      DOTFILES_DIR="/home/${username}/${nixosConfigDir}/dotfiles"
      DOTBOT_CONFIG="$DOTFILES_DIR/install.conf.yaml"

      if [ ! -d "$DOTFILES_DIR" ] || [ ! -f "$DOTBOT_CONFIG" ]; then
        echo "Skipping Dotbot: $DOTFILES_DIR or install.conf.yaml not found"
        exit 0
      fi

      if [ -n "${preferredWallpaperDirectory}" ] && [ -d "${preferredWallpaperDirectory}" ]; then
        WALLPAPER_ROOT="${preferredWallpaperDirectory}"
      else
        WALLPAPER_ROOT="/home/${username}/${nixosConfigDir}/wallpapers"
      fi

      MONITOR_RESOLUTION="${monitorResolution}" \
      WALLPAPER_ROOT="$WALLPAPER_ROOT" \
      ${pkgs.dotbot}/bin/dotbot \
        -d "$DOTFILES_DIR" \
        -c "$DOTBOT_CONFIG"
    '';
  };
}
