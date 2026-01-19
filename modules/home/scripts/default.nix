{
  pkgs,
  username,
  host,
  profile,
  ...
}:
{
  home.packages = [
    (import ./emopicker.nix { inherit pkgs; })
    (import ./nvidia-offload.nix { inherit pkgs; })
    (import ./hm-find.nix { inherit pkgs; })
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
