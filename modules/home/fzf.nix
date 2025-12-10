# Fzf is a general-purpose command-line fuzzy finder.
{
  config,
  lib,
  ...
}: let
  accent = "#89b4fa"; # catppuccin blue
  foreground = "#cdd6f4"; # catppuccin text
  muted = "#585b70"; # catppuccin surface1
in {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
    };
    defaultOptions = [
      "--margin=1"
      "--layout=reverse"
      "--border=none"
      "--info='hidden'"
      "--header=''"
      "--prompt='--> '"
      "-i"
      "--no-bold"
      "--bind='enter:execute(nvim {})'"
      "--preview='bat --style=numbers --color=always --line-range :500 {}'"
      "--preview-window=right:60%:wrap"
    ];
  };
}
