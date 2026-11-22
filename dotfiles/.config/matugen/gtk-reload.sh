#!/usr/bin/env sh
# Force GTK apps to re-read their theme (and matugen's colors.css) after it changes.
# Uses dconf instead of gsettings: gsettings needs the org.gnome.desktop.interface
# schema, which isn't installed on this minimal setup, whereas dconf (already on
# PATH) writes raw dconf paths directly.

THEME=$(dconf read /org/gnome/desktop/interface/gtk-theme)
dconf write /org/gnome/desktop/interface/gtk-theme "''"
dconf write /org/gnome/desktop/interface/gtk-theme "$THEME"
