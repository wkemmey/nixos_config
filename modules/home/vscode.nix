{
  pkgs,
  config,
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
      
      # Stylix will merge its settings with this profile automatically
      # No userSettings needed here - Stylix handles all theming
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