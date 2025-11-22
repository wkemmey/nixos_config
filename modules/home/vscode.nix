{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;

    # User settings - these will be merged with Stylix-generated settings
    userSettings = {
      # Font sizes for different UI elements
      "chat.editor.fontSize" = 16; # AI chat input font size
      "markdown.preview.fontSize" = 16; # Chat response preview size
      "terminal.integrated.fontSize" = 16; # Integrated terminal
    };

    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          jeff-hykin.better-nix-syntax
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
          tamasfe.even-better-toml
          usernamehw.errorlens
        ];
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