{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Use greetd + tuigreet (TUI) to launch Niri. Disable other DMs.
  services.displayManager.sddm.enable = false;
  services.displayManager.ly.enable = false;

  # Keep niri available at system level and ensure session package is present
  programs.niri.package = pkgs.niri;
  services.displayManager.sessionPackages = [ pkgs.niri ];
}
