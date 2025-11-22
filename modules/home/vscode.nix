{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    
    # Allow VSCode to manage extensions and settings mutably
    # This prevents conflicts with Stylix trying to manage the same files
    mutableExtensionsDir = true;
    
    # Let Stylix handle all theming through userSettings
    # Don't use profiles when Stylix is managing VSCode
    extensions = with pkgs.vscode-extensions; [
      jeff-hykin.better-nix-syntax
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      tamasfe.even-better-toml
      usernamehw.errorlens
    ];
    
    # Note: All font sizes and colors are managed by Stylix
    # via the vscode.enable target in modules/home/stylix.nix
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