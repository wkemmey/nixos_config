{
  config,
  lib,
  pkgs,
  username,
  host,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  vaultDir = variables.obsidianVaultDir or "";
in
{
  config = lib.mkIf (vaultDir != "") {
    # Periodically commit and push the Obsidian vault to GitHub for version
    # history. Runs as the user so it uses their git identity and gh credentials.
    systemd.services.obsidian-vault-backup = {
      description = "Commit and push the Obsidian vault to GitHub";
      serviceConfig = {
        Type = "oneshot";
        User = username;
        Group = "users";
        Environment = [ "HOME=/home/${username}" ];
      };
      path = with pkgs; [
        git
        gh
        coreutils
      ];
      script = ''
        set -u

        # skip silently until the vault has been initialized as a repo
        if [ ! -d "${vaultDir}/.git" ]; then
          exit 0
        fi

        cd "${vaultDir}" || exit 1

        # commit only when there are uncommitted changes
        if [ -n "$(git status --porcelain)" ]; then
          git add -A
          git commit -m "auto backup: $(date -Is)"
        fi

        # push any unpushed commits (also recovers from a previous failed push)
        git push
      '';
    };

    systemd.timers.obsidian-vault-backup = {
      description = "Back up the Obsidian vault to GitHub every 30 minutes";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "30min";
        Persistent = true;
      };
    };
  };
}
