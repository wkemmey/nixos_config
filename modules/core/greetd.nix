{ config, lib, pkgs, username, ... }: {
  # configure greetd unconditionally; it will be enabled by default only when other
  # display managers (sddm, ly) are not enabled
  services.greetd = {
    enable = lib.mkDefault (
      !config.services.displayManager.sddm.enable && !config.services.displayManager.ly.enable
    );

    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter-session -- --session Niri --user ${username}";
      };
    };
  };
}
