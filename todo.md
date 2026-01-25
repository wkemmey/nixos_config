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
- make it so i can change themes - set up noctalia to manage themes
- check each file in /etc/profiles/per-user/whit/bin -- do i want it?
- ensure xbox controller is working

- create rust directory merger project


next steps:
set up noctalia to control all themes, incl firefox






i'm using nixos with niri and noctalia shell. noctalia has the ability to choose a theme for noctalia and optionally apply this to a preconfigured set of other tools/apps. how does this work? is it compatible with nixos? is it a good idea if i want to be able to switch themes occasionally? 


i'm using home manager for a few things, which i'm comfortable handling through nix config, but most of my software is configured through dotfiles. in my .config directory, i have simlinks to a git repo, but the files in the git repo are writeable, so i think this would work with noctalia. does noctalia update theme settings in other apps but leave the rest of the config alone, or does it overwrite whole config files (which would undo non-theme options that i have configured) 



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

