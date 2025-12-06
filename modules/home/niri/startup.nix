{
  host,
  wallpaperImage,
  startupApps,
  barChoice,
  ...
}:
let
  barStartupCommand =
    if barChoice == "noctalia" then
      ''spawn-at-startup "noctalia-shell"''
    else
      ''// ${barChoice} started via systemd service'';
in
''
  spawn-at-startup "bash" "-c" "wl-paste --watch cliphist store &"
  ${barStartupCommand}
  spawn-at-startup "swww-daemon"
  spawn-at-startup "bash" "-c" "sleep 1 && swww img ${wallpaperImage}"
  spawn-at-startup "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
  spawn-at-startup "vesktop"
  spawn-at-startup "Telegram"
''
