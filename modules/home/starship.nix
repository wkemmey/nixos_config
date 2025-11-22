# starship is a minimal, fast, and extremely customizable prompt for any shell!
{
  config,
  lib,
  host,
  ...
}:
let
  # Use comment color for subtle, unobtrusive prompt
  comment = "#${config.lib.stylix.colors.base03}";  # Muted gray like code comments
  dimmed = "#${config.lib.stylix.colors.base04}";   # Slightly brighter for active elements

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
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$nix_shell"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "\n"
        "$character"
      ];
      directory = {
        style = comment;
        truncation_length = 4;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](${dimmed})";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](${comment})";
      };

      nix_shell = {
        format = "[$symbol]($style) ";
        symbol = "󱄅";
        style = comment;
      };

      git_branch = {
        symbol = " ";
        style = comment;
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        format = "[($all_status$ahead_behind)]($style)";
        style = comment;
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
        style = comment;
      };
    };
  };
}
