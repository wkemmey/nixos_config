{pkgs}:
pkgs.writeShellScriptBin "cheatsheet" ''
  ${pkgs.fuzzel}/bin/fuzzel --dmenu \
    --prompt "Shortcuts " \
    --width 80 \
    --lines 40 <<'EOF' >/dev/null
[System]
Mod+Space — launcher (noctalia)
Mod+T / Mod+Enter — terminal (foot)
Mod+O — overview
Mod+Z — lock screen
Mod+Shift+Q — quit niri
Mod+Alt+P — power off monitors
Mod+Shift+/ — this cheat sheet
[Apps]
Mod+B — Obsidian
Mod+F — Firefox
Mod+S — OBS Studio
Mod+E — Thunar (files)
Mod+Ctrl+E — emoji picker
Mod+Shift+E — emoji search
[Windows]
Mod+Q — close window
Mod+W — toggle floating
Mod+Ctrl+W — focus floating/tiling
Mod+Alt+F — maximize column
Mod+Shift+F — fullscreen
Mod+Shift+V — tabbed columns
[Navigation]
Mod+H/J/K/L — focus (arrows too)
Mod+Ctrl+H/J/K/L — move window
Mod+Home/End — column first/last
[Workspaces]
Mod+1..9 — focus workspace
Mod+Ctrl+1..9 — move to workspace
Mod+PageUp/Down — switch workspace
[Sizing]
Mod+R — column width preset
Mod+Shift+R — window height preset
Mod+Ctrl+R — reset window height
Mod+-/= — column width
Mod+Shift+-/= — window height
[Screenshots]
Print — screenshot
Ctrl+Print — screenshot screen
Alt+Print — screenshot window
[Cast & Color]
Mod+C — pick color -> copy
Mod+P — cast monitor
Mod+Shift+P — cast window
Mod+Ctrl+P — clear cast
EOF
''
