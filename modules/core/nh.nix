{ pkgs, username, host, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  nixosConfigDir = variables.nixosConfigDir or "nixos_config";
in {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/${nixosConfigDir}";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
