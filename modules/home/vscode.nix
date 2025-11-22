{
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # Force VSCode to use native Wayland for proper font rendering and scaling
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.vscode = {
    enable = true;
    
    # Enable Wayland support explicitly
    package = pkgs.vscode;
    
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
      
      # Stylix handles all font sizes - with native Wayland rendering,
      # fonts should display at the correct size
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