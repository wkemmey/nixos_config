{ pkgs }:
let
  # English base Whisper model (~142 MB), pinned in the Nix store.
  model = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin";
    hash = "sha256-oDd5yG3zMjB19eeWyyzlAp8A7Ihp7uP9+4l6/jbG0AI=";
  };
in
pkgs.writeShellScriptBin "dictate" ''
  set -eu

  # "enter" = append a Return keystroke after typing (used by Mod+V)
  mode="''${1:-}"

  dir="''${XDG_RUNTIME_DIR:-/tmp}/dictate"
  mkdir -p "$dir"
  wav="$dir/recording.wav"
  pidfile="$dir/record.pid"
  out="$dir/out"

  if [ -f "$pidfile" ]; then
    # recording is active: stop, transcribe, type
    kill "$(cat "$pidfile")" 2>/dev/null || true
    rm -f "$pidfile"
    sleep 0.4

    ${pkgs.whisper-cpp}/bin/whisper-cli -m ${model} -f "$wav" -otxt -of "$out" -np 2>/dev/null

    text=""
    if [ -f "$out.txt" ]; then
      text="$(${pkgs.coreutils}/bin/cat "$out.txt" \
        | ${pkgs.gnused}/bin/sed 's/\[BLANK_AUDIO\]//g' \
        | ${pkgs.coreutils}/bin/tr -s '[:space:]' ' ' \
        | ${pkgs.gnused}/bin/sed 's/^ *//; s/ *$//')"
      rm -f "$out.txt"
    fi
    rm -f "$wav"

    if [ -n "$text" ]; then
      ${pkgs.wtype}/bin/wtype "$text"
      if [ "$mode" = "enter" ]; then
        ${pkgs.wtype}/bin/wtype -k Return
      fi
      ${pkgs.libnotify}/bin/notify-send -t 2000 "Dictation" "Typed" &
    else
      ${pkgs.libnotify}/bin/notify-send -t 2500 "Dictation" "No speech detected" &
    fi
  else
    # start recording (16 kHz mono WAV from the default source = HyperX QuadCast S)
    ${pkgs.pipewire}/bin/pw-record --rate 16000 --channels 1 "$wav" >/dev/null 2>&1 &
    echo $! > "$pidfile"
    ${pkgs.libnotify}/bin/notify-send -t 1500 "Dictation" "Listening..." &
  fi
''
