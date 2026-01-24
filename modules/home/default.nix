{ pkgs, inputs, host, lib, ... }:
{
  imports = [
    ./virtmanager.nix
    ./vscode.nix
    ./obs-studio.nix
    ./scripts
  ];

  # initialize matugen.kdl if missing to prevent niri from breaking
  home.activation.initMatugen = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD [ -f ~/.config/niri/matugen.kdl ] || ${pkgs.matugen}/bin/matugen color hex '#808080'
  '';
}
