{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    # Prefer the Catppuccin Mocha color theme; stylix will also attempt to
    # generate a matching theme when `stylix.targets.vscode.enable = true`.
    settings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
    };
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          jeff-hykin.better-nix-syntax
          ms-vscode.cpptools-extension-pack
          vscodevim.vim # Vim emulation
          mads-hartmann.bash-ide-vscode
          tamasfe.even-better-toml
          zainchen.json
        ];
      };
    };
  };
}
