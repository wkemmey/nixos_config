{
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # extensions managed by nix (declarative, reproducible)
    # settings managed via dotfiles (easier to edit frequently)
    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat
      jeff-hykin.better-nix-syntax
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      tamasfe.even-better-toml
      usernamehw.errorlens
    ];
  };
}