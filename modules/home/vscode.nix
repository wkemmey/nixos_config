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
        # Note: All font sizes (including chat/markdown preview) are managed by Stylix
        # via the vscode.enable target in modules/home/stylix.nix
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