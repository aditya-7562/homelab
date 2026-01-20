#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/backups"
SOURCE_DIR="/homelab"

echo "[+] Starting backup at $TIMESTAMP"

mkdir -p "$BACKUP_DIR"

ARCHIVE_NAME="homelab_backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
  "$SOURCE_DIR/system/data" \
  "$SOURCE_DIR/jenkins/jenkins_home" \
  "$SOURCE_DIR/n8n/data"

echo "[✓] Backup completed: $BACKUP_DIR/$ARCHIVE_NAME"
