# TODO

- once the next version of niri releases, consider setting up press and release options for mod+v
  to enable push-to-talk

- setup AGENTS.md

Looking at your system, here are some good candidates for matugen integration:

Already Integrated ✅
Noctalia (shell/bar)
Niri (compositor borders/focus)
Foot (terminal)
Fuzzel (launcher - via emoji picker)
VS Code
Fastfetch (system info)
Firefox (via Pywalfox)
gtk (thunar, gedit)

Worth Integrating

Helix - Your helix editor could match
Yazi - File manager colors
Btop/Bottom/Htop - System monitors
Bat - Code viewer
Starship - Prompt colors (though it already has some theming)

Lower Priority:

Lazygit - Git TUI colors





software that i currently use in windows:

calibre
calculator
anki
davinci or similar

don't forget to save my wallpaper dump from pictures






sonos





is it possible to remove all the generated color files from my repo, so i don't get a bunch of changed files just by changing wallpaper?  be careful not to break the initial install--might need to run matugen hooks upon install to generate the missing color files.
make some sensible niri bindings based around the jkli keys, and make helix use those too




should i make poweronboot false for laptops?

Enable Hardware Acceleration in NixOS

    If you have an NVIDIA GPU:
    Enable NVIDIA's VA-API translation layer (nvidia-vaapi-driver) so browsers and media players can hardware-decode AV1/HEVC/VP9 streams:
    Nix

    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];
      };
      environment.sessionVariables = {
        NVD_BACKEND = "direct";
        MOZ_DISABLE_RDD_SANDBOX = "1"; # Needed for Firefox hardware decode on NVIDIA
      };
    }

    If you have an Intel or AMD GPU:
    Enable VA-API drivers (intel-media-driver for newer Intel or mesa for AMD):
    Nix

    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver # For Intel Broadwell (Gen 8) and newer
          libvdpau-va-gl
        ];
      };
    }

