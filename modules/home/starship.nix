# starship is a minimal, fast, and extremely customizable prompt for any shell!
{
  config,
  lib,
  host,
  ...
}:
let
  # Use brightest color for prompt, keep right-side info subtle
  bright = "#${config.lib.stylix.colors.base07}";  # Brightest color for prompt
  subtle = "#${config.lib.stylix.colors.base04}";  # Subtle color for right-side info

  # Import variables to check shell choice
  variables = import ../../hosts/${host}/variables.nix;
  defaultShell = variables.defaultShell or "zsh";
in
{
  programs.starship = {
    # Starship works great with all shells including Fish
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$character"
      ];
      right_format = lib.concatStrings [
        "$nix_shell"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
      ];
      directory = {
        style = subtle;
        truncation_length = 4;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](${bright})";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](${bright})";
      };

      nix_shell = {
        format = "[$symbol]($style) ";
        symbol = "󱄅";
        style = subtle;
      };

      git_branch = {
        symbol = " ";
        style = subtle;
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        format = "[($all_status$ahead_behind)]($style)";
        style = subtle;
        conflicted = "~";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "≡";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        style = subtle;
      };
    };
  };
}
