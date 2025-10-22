{ config, pkgs, mySettings, ... }:

{
  # Set the home directory and state directory
  home.username = "whit"; #"${mySettings.username}";
  home.homeDirectory = "/home/whit"; #"/home/${mySettings.username}";
  home.stateVersion = "25.05"; # Match your NixOS state version
  
  #programs.bash = {
  #  enable = true;
  #  shellAliases = {
  #    ll = "ls -l";
  #    .. = "cd ..";
  #  };
  #};
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      #.. = "cd ..";
    };
  };

  programs.git = {
    enable = true;
    userName = "whit"; #"${mySettings.name}";
    userEmail = "whit@fastmail.com"; #"${mySettings.email}";
    extraConfig = {
      init.defaultBranch = "main";
      #safe.directory = [ "/etc/nixos" "${mySettings.dotfilesDir}" ];
      safe.directory = [ "/etc/nixos" "~/.dotfiles" ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    # Environment variables (as a list of strings)
    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "GDK_BACKEND,wayland"
    ];

    # Variables (Note the correct Nix string syntax using ${...})
    "$mainMod" = "SUPER";
    "$terminal" = "${pkgs.foot}/bin/foot";
    "$browser" = "${pkgs.chromium}/bin/chromium"; # Use absolute path for robustness
    "$fileManager" = "${pkgs.nautilus}/bin/nautilus";
    "$music" = "${pkgs.vlc}/bin/vlc";

    # Monitor setup
    monitor = "=,preferred,auto,1";

    # Keybinds (as a list of strings)
    bind = [
      # Window Actions
      "$mainMod, Q, exec, $terminal"
      "$mainMod, C, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, ${pkgs.rofi}/bin/rofi -show drun"
      "$mainMod, V, togglefloating,"

      # Window Management
      "$mainMod, P, pseudo," # dwindle
      "$mainMod, J, togglesplit," # dwindle

      # Move Focus (Note: You had J defined twice, once for togglesplit and once for movefocus. You should fix this!)
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      # (Check your keybind for J)

      # Move Windows
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      # ... other movewindow binds ...

      # Workspace Switching
      "$mainMod, 1, workspace, 1"
      # ... up to 4

      # Move Windows to Workspaces
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      # ... up to 4

      # Applications
      "$mainMod, A, exec, $browser https://chatgpt.com"
      # ... other browser/app binds ...
    ];

    # Mouse binds (already in your file, kept here)
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # Other non-keybind configurations (e.g., from your existing file)
    decoration = {
      shadow_offset = "0 5";
      "col.shadow" = "rgba(00000099)";
    };
  };

  # You can keep the plugins list as-is:
  #wayland.windowManager.hyprland.plugins = [
  #  pkgs.hyprlandPlugins.PLUGIN_NAME
  #];
}