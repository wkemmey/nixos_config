{
  pkgs,
  username,
  host,
  profile,
  ...
}:
{
  home.packages = [
    (import ./emopicker9000.nix { inherit pkgs; })
    (import ./keybinds.nix { inherit pkgs; })
    (import ./nvidia-offload.nix { inherit pkgs; })
    (import ./wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ./web-search.nix { inherit pkgs; })
  # Waybar and rofi-related helper scripts removed
    (import ./screenshootin.nix { inherit pkgs; })
    (import ./hm-find.nix { inherit pkgs; })
    (import ./zed-fix.nix { inherit pkgs; })
    (import ./niri-gaming-mode.nix { inherit pkgs; })
    (import ./webapp-install.nix { inherit pkgs; })
    (import ./webapp-remove.nix { inherit pkgs; })
    (import ./dcli.nix {
      inherit pkgs host profile;
      backupFiles = [
        ".config/mimeapps.list.backup"
      ];
    })
  ];
}
