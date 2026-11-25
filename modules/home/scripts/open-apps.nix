{pkgs}:
pkgs.writeShellScriptBin "open-apps" ''
  set -eu

  # find the first empty workspace (lowest index 1-9 with no active window)
  occupied="$(${pkgs.niri}/bin/niri msg -j workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.active_window_id != null) | .idx')"

  target=""
  for i in 1 2 3 4 5 6 7 8 9; do
    if ! printf '%s\n' "$occupied" | ${pkgs.gnugrep}/bin/grep -qx "$i"; then
      target="$i"
      break
    fi
  done

  # focus the empty workspace (creates it if needed); if all 9 are taken, stay put
  if [ -n "$target" ]; then
    ${pkgs.niri}/bin/niri msg action focus-workspace "$target"
  fi

  # spawn the apps in order, each opening on the focused workspace.
  # small sleeps so they map in order (left to right); bump if the order is off.
  ${pkgs.niri}/bin/niri msg action spawn -- gtk-launch fastmail
  ${pkgs.coreutils}/bin/sleep 1
  ${pkgs.niri}/bin/niri msg action spawn -- obsidian
  ${pkgs.coreutils}/bin/sleep 1
  ${pkgs.niri}/bin/niri msg action spawn -- slack
  ${pkgs.coreutils}/bin/sleep 1
  ${pkgs.niri}/bin/niri msg action spawn -- gtk-launch youtube-music
''
