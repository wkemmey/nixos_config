{ username, host, lib, ... }: 
let
  inherit (import ../../hosts/${host}/variables.nix) enableSyncthing;
in
lib.mkIf enableSyncthing {
  services.syncthing = {
    enable = true;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
}
