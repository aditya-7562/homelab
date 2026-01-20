#!/usr/bin/env bash
set -euo pipefail

echo "[+] Starting bootstrap process..."

# ---------- sanity checks ----------
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run as root (sudo)"
  exit 1
fi

# ---------- update system ----------
echo "[+] Updating system packages..."
apt update -y

# ---------- install docker ----------
if ! command -v docker >/dev/null 2>&1; then
  echo "[+] Installing Docker..."
  apt install -y ca-certificates curl gnupg lsb-release
  curl -fsSL https://get.docker.com | sh
else
  echo "[✓] Docker already installed"
fi

# ---------- install docker compose ----------
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "[+] Installing Docker Compose..."
  apt install -y docker-compose
else
  echo "[✓] Docker Compose already installed"
fi

# ---------- enable docker ----------
systemctl enable docker
systemctl start docker

# ---------- create docker network ----------
if ! docker network ls | grep -q homelab_proxy; then
  echo "[+] Creating Docker network: homelab_proxy"
  docker network create homelab_proxy
else
  echo "[✓] Docker network homelab_proxy already exists"
fi

# ---------- directory structure ----------
BASE_DIR="/homelab"
echo "[+] Ensuring directory structure under $BASE_DIR"

mkdir -p $BASE_DIR/{system,jenkins,n8n,portfolio}

# ---------- start core services ----------
echo "[+] Starting core services..."

for service in system jenkins n8n portfolio; do
  if [ -f "${BASE_DIR}/${service}/docker-compose.yml" ]; then
    echo "[+] Starting ${service}..."
    docker compose -f "${BASE_DIR}/${service}/docker-compose.yml" up -d
  else
    echo "[!] Skipping ${service}: docker-compose.yml not found"
  fi
done

echo "[✓] Bootstrap complete"
echo "[i] Verify services via Nginx Proxy Manager and Jenkins UI"
