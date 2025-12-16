{pkgs}:
pkgs.writeShellScriptBin "hm-find" ''
  #!/usr/bin/env bash

  # script metadata
  #===============================================
  # this script searches recent journalctl entries for home manager errors;
  # it identifies backup files that prevent rebuilds and allows removal
  # author: don williams
  # creation date: may 6th, 2025
  # revision history:
  #-----------------------------------------------
  # 0.1 - 5/6/25 - initial version
  # 0.2 - 5/7/25 - improved messaging, added log directory check

  # display warning message
  echo "==============================================="
  echo "            ⚠️ WARNING ⚠️            "
  echo "==============================================="
  echo "*** This script is experimental! ***"
  echo "It will attempt to find old backup files that are preventing Home Manager from rebuilding."
  echo "If conflicting files are found, you will be prompted to remove them."
  echo "A log of any deletions will be stored in \$HOME/hm-logs."
  echo "==============================================="

  # define the time range (default: last 30 minutes)
  TIME_RANGE="30m"
  LOG_DIR="$HOME/hm-logs"
  LOG_FILE="$LOG_DIR/hm-cleanup-$(date +'%Y-%m-%d_%H-%M-%S').log"

  # ensure the log directory exists
  if [ ! -d "$LOG_DIR" ]; then
      echo "Creating log directory: $LOG_DIR"
      mkdir -p "$LOG_DIR"
  fi

  # search journal logs for backup conflicts and extract file paths
  FILES=$(journalctl --since "-$TIME_RANGE" -xe | grep hm-activate | awk -F "'|'" '/would be clobbered by backing up/ {print $2}')

  # check if any files were found
  if [ -z "$FILES" ]; then
      echo "No conflicting backup files found in the last $TIME_RANGE."
      exit 0
  fi

  # display found backup files
  echo "🚨 The following backup files are preventing Home Manager from rebuilding:"
  echo "$FILES" | tr ' ' '\n'

  # ask for user confirmation before deletion
  read -p "❓ Do you want to remove these files? (y/N): " confirm

  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      echo "🗑️ Deleting files..." | tee -a "$LOG_FILE"
      echo "$FILES" | xargs rm -v | tee -a "$LOG_FILE"
      echo "✅ Cleanup completed at $(date)" | tee -a "$LOG_FILE"
  else
      echo "⛔ No files were removed." | tee -a "$LOG_FILE"
  fi
''
