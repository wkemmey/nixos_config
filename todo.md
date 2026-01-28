# TODO

- [ ] Print test page once a week
- [ ] keyboard command to shutdown
- microphone not working
- 1password
- way to set credentials on google, etc
- are all files in hosts still useful
- clean up variables
- clean up comments
- make some webapps
- install helix
- install ai tools
- install dropbox (can i put it on different drive)
- set up rust and python dev environments
- get steam working
- setup AGENTS.md
- check each file in /etc/profiles/per-user/whit/bin -- do i want it?
- ensure xbox controller is working
- nordvpn
- mtg arena
- distrobox
- slack app
- what else from windows install?
- bluetooth headphones
- connect to ntfs hard drives

- create rust directory merger project

- dev shell for python, ruby, ruby on rails, rust



 ---

 i need to theme firefox and everything else


 do i want to use any of the templates from the matugen themes github

 i need to see why fixes didn't resolve boot errors




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

The most effective way to hide an app from Noctalia (and almost any other launcher like Fuzzel or Rofi) is to set NoDisplay=true in its .desktop file. On NixOS, you don't edit these files directly in /usr/share/applications/; you use Home Manager or a Nix override.  

Using Home Manager (Recommended)

You can use xdg.desktopEntries to "shadow" an existing app and hide it:
Nix

xdg.desktopEntries = {
  "program-name-to-hide" = {
    name = "Program Name";
    noDisplay = true; # This is the magic line
  };
};

Note: The attribute name (e.g., "program-name-to-hide") must match the filename of the original .desktop file without the extension.





troubleshoot errors:
journalctl -b -1 -t niri -t noctalia


software that i currently use in windows:
epic games
slack
gog
battle.net
wmware
calibre
mtg arena
calculator
anki
epson printer software
adobe
imazing
turbotax
davinci or similar

don't forget to save my wallpaper dump from pictures