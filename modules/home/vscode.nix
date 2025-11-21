{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
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

  # Provide a default VSCode settings template that will be copied into the
  # user's config only if the real file does not already exist. This avoids
  # attempting to set a non-existent `programs.vscode.settings` option and
  # preserves any user customizations.
  home.file.".config/Code/User/settings.json.template" = {
    text = builtins.toJSON {
      "workbench.colorTheme" = "Catppuccin Mocha";
    };
  };

  home.activation.vscodeSettingsInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
    TEMPLATE_FILE="$HOME/.config/Code/User/settings.json.template"

    if [ ! -f "$SETTINGS_FILE" ] || [ -L "$SETTINGS_FILE" ]; then
      $DRY_RUN_CMD rm -f "$SETTINGS_FILE"
      $DRY_RUN_CMD cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
      $DRY_RUN_CMD chmod 644 "$SETTINGS_FILE"
    fi
  '';
}
}
