{ host, ... }:
''
  // Host-specific keybinds for leno-desktop

  // === Gaming Mode Toggle ===
  Ctrl+Shift+G hotkey-overlay-title="Toggle Gaming Mode" {
      spawn "niri-gaming-mode.sh";
  }

  Mod+Shift+G hotkey-overlay-title="Open Github" {
        spawn "gtk-launch" "Github.desktop";
  }
  Mod+Shift+C hotkey-overlay-title="Open Claude AI" {
      spawn "gtk-launch" "Claude AI.desktop";
  }
''
