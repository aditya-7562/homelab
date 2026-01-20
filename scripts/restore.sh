#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run as root (sudo)"
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: sudo ./restore.sh <backup-archive.tar.gz>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "[-] Backup file not found: $BACKUP_FILE"
  exit 1
fi
BASE_DIR="/homelab"

echo "[!] This will overwrite existing data under $BASE_DIR"
read -p "Continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "[-] Restore aborted"
  exit 1
fi

echo "[+] Stopping running containers..."
cd $BASE_DIR/system && docker-compose down
cd $BASE_DIR/jenkins && docker-compose down
cd $BASE_DIR/n8n && docker-compose down
cd $BASE_DIR/portfolio && docker-compose down

echo "[+] Restoring data from $BACKUP_FILE"
tar -xzf "$BACKUP_FILE" -C /

echo "[+] Restarting services..."
cd $BASE_DIR/system && docker-compose up -d
cd $BASE_DIR/jenkins && docker-compose up -d
cd $BASE_DIR/n8n && docker-compose up -d
cd $BASE_DIR/portfolio && docker-compose up -d

echo "[✓] Restore complete"
echo "[i] Validate Jenkins, NPM, and application availability"
