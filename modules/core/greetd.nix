{ config, lib, pkgs, username, ... }: {
  # configure greetd unconditionally; it will be enabled by default only when other
  # display managers (sddm, ly) are not enabled
  services.greetd = {
    enable = lib.mkDefault (
      !config.services.displayManager.sddm.enable && !config.services.displayManager.ly.enable
    );

    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session"; 
      };
    };
  };
}
