{pkgs, ...}: {
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
          rust-lang.rust-analyzer          #vscodevim.vim # Vim emulation
          vadimcn.vscode-lldb
          serayuzgur.crates
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