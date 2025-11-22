{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    # Prefer the Catppuccin Mocha color theme; stylix will also attempt to
    # generate a matching theme when `stylix.targets.vscode.enable = true`.
    #userSettings = {
    #  "workbench.colorTheme" = "Catppuccin Mocha";
    #};
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          jeff-hykin.better-nix-syntax
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
          serayuzgur.crates
          tamasfe.even-better-toml
          usernamehw.errorlens
        ];
      };
    };
  };

  # Provide a default VSCode settings template
  home.file.".config/Code/User/settings.json.template" = {
    text = builtins.toJSON {
      #"workbench.colorTheme" = "Catppuccin Mocha";
      # Font sizes for different UI elements
      "chat.editor.fontSize" = 16; # AI chat input font size
      "markdown.preview.fontSize" = 16; # Chat response preview size
      "terminal.integrated.fontSize" = 16; # Integrated terminal
    };
  };

  home.activation.vscodeSettingsInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
    TEMPLATE_FILE="$HOME/.config/Code/User/settings.json.template"

    if [ ! -f "$SETTINGS_FILE" ] || [ -L "$SETTINGS_FILE" ]; then
      $DRY_RUN_CMD rm -f "$SETTINGS_FILE"
      $DRY_RUN_CMD cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
      $DRY_RUN_CMD chmod 644 "$SETTINGS_FILE"
    fi
  '';
}
#"editor.semanticTokenColorCustomizations": {
#    "[ (Name of the theme you're using here) ]": {
#        "rules": {
#            "*.mutable": {
#                "fontStyle": "italic"
#            }
#        }
#    }
#}