{ inputs, host, lib, ... }:
{
  imports = [
    ./virtmanager.nix
    ./vscode.nix
    ./obs-studio.nix
    ./scripts
  ];
}
