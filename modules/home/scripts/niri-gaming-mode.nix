{ pkgs }:

pkgs.writeShellScriptBin "niri-gaming-mode.sh" ''
  # toggle niri gaming mode - adds spacing between monitors to trap cursor on main display
  # bind to ctrl+shift+g for quick gaming mode toggle

  STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/niri-gaming-mode-state"

  # normal positions (from your config)
  NORMAL_DP1_X=2740
  NORMAL_DP1_Y=1455
  NORMAL_DP2_X=820
  NORMAL_DP2_Y=1714
  NORMAL_DP3_X=6180
  NORMAL_DP3_Y=1714

  # gaming positions (adds large gaps to prevent cursor movement)
  # dp-1 stays in same position, but dp-2 and dp-3 move far away
  GAMING_DP1_X=2740
  GAMING_DP1_Y=1455
  GAMING_DP2_X=-10000   # move left monitor far to the left
  GAMING_DP2_Y=1714
  GAMING_DP3_X=20000    # move right monitor far to the right
  GAMING_DP3_Y=1714

  if [ -f "$STATE_FILE" ]; then
      # gaming mode is on, switch to normal
      echo "Switching to NORMAL mode - monitors adjacent"
      niri msg output DP-1 position set -- $NORMAL_DP1_X $NORMAL_DP1_Y
      niri msg output DP-2 position set -- $NORMAL_DP2_X $NORMAL_DP2_Y
      niri msg output DP-3 position set -- $NORMAL_DP3_X $NORMAL_DP3_Y
      rm "$STATE_FILE"
      ${pkgs.libnotify}/bin/notify-send "Gaming Mode OFF" "Monitors restored to normal positions" -i input-gaming
  else
      # gaming mode is off, switch to gaming
      echo "Switching to GAMING mode - cursor trapped on main monitor"
      niri msg output DP-1 position set -- $GAMING_DP1_X $GAMING_DP1_Y
      niri msg output DP-2 position set -- $GAMING_DP2_X $GAMING_DP2_Y
      niri msg output DP-3 position set -- $GAMING_DP3_X $GAMING_DP3_Y
      touch "$STATE_FILE"
      ${pkgs.libnotify}/bin/notify-send "Gaming Mode ON" "Cursor confined to main monitor (DP-1)" -i input-gaming
  fi
''
