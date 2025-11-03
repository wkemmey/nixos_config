{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  # Set icon theme for Qt applications
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
  };
}
