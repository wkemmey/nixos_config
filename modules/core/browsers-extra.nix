{
  config,
  lib,
  pkgs,
  helium-browser,
  host,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    #vivaldi # Privacy-focused browser
    #brave # Privacy browser with ad blocking
    #chromium # Open source Chrome
    #google-chrome # Google Chrome
    firefox # Mozilla Firefox
    helium-browser # Helium browser
  ];
}
