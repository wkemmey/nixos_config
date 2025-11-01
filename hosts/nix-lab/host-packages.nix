{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Steam Deck gaming essentials
    steam
    steam-run
    gamescope
    gamemode
    mangohud

    # Controller support
    antimicrox

    # Essential tools
    git
    wget
    curl
  ];
}
