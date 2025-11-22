{
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    
    # Fully declarative: Nix manages extensions, Stylix manages theming
    # Both can coexist in profiles without conflict
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jeff-hykin.better-nix-syntax
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        tamasfe.even-better-toml
        usernamehw.errorlens
      ];
      
      # Override chat font to be explicitly larger than Stylix's calculated value
      # Using mkForce to override Stylix's setting
      userSettings = {
        "chat.editor.fontSize" = lib.mkForce 24;
        "inlineChat.fontSize" = lib.mkForce 24;
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