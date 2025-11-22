{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;

    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          jeff-hykin.better-nix-syntax
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
          tamasfe.even-better-toml
          usernamehw.errorlens
        ];
        
        # User settings - override only what Stylix doesn't handle
        # Stylix manages: editor font, UI font, terminal font
        # We set chat/preview areas to match Stylix's applications size
        userSettings = {
          "chat.editor.fontSize" = config.stylix.fonts.sizes.applications; # AI chat input
          "markdown.preview.fontSize" = config.stylix.fonts.sizes.applications; # Chat response preview
          # Note: integrated terminal font is managed by Stylix via terminal size
        };
      };
    };
  };
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