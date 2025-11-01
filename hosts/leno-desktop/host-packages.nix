{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix)
    davinciResolveEnable
    ;
in
{
  environment.systemPackages =
    with pkgs;
    [
      audacity
      boxbuddy
      bottles
      discord
      nodejs

      # Lightworks with font rendering fix via extraBwrapArgs
      (lightworks.overrideAttrs (oldAttrs: {
        extraBwrapArgs = (oldAttrs.extraBwrapArgs or [ ]) ++ [
          "--tmpfs"
          "/usr/share/fonts"
          "--ro-bind-try"
          "/run/current-system/sw/share/X11/fonts"
          "/usr/share/fonts"
        ];
      }))
    ]
    ++ lib.optionals davinciResolveEnable [
      davinci-resolve
    ];
}
