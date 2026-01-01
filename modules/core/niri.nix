{ pkgs, ... }: {
  # niri wayland compositor configuration
  programs.niri.package = pkgs.niri;
  services.displayManager.sessionPackages = [ pkgs.niri ];
}
