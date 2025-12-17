{ config, lib, pkgs, helium-browser, host, ... }: {
  environment.systemPackages = (with pkgs; [
    #vivaldi # privacy-focused browser
    #brave # privacy browser with ad blocking
    #chromium # open source chrome
    #google-chrome # google chrome
  ]) ++ [
    helium-browser # helium browser (from flake input)
  ];
}
