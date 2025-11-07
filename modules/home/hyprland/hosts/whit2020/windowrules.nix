{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  # Host-specific window rules for whit2020
  # These will be merged with the default window rules
  windowrule = [
    # Add host-specific window rules here
  ];
}
