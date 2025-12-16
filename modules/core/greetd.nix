{ config, lib, pkgs, username, ... }:
{
  # Configure greetd unconditionally. It will be enabled by default only when other
  # display managers (sddm, ly) are not enabled.
  services.greetd = {
    enable = lib.mkDefault (
      !config.services.displayManager.sddm.enable && !config.services.displayManager.ly.enable
    );
    # vt = 3;  # REMOVED: VT is now fixed to VT1 in nixpkgs-unstable
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session"; 
      };
    };
  };
}
