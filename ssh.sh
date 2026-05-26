#!/bin/bash

set -e

# =========================
# CONFIG (REPLACE THIS)
# =========================
TAILSCALE_AUTHKEY="tskey-auth-k9jqhnFtph11CNTRL-FvkmeFS1FrFd7oEffMw1rFfuU8ohDu8oX"

echo "=== Updating system ==="
su -c "apt update && apt upgrade -y"

echo "=== Installing SSH server ==="
su -c "apt install -y openssh-server"
su -c "systemctl enable ssh"
su -c "systemctl start ssh"

echo "=== Installing Tailscale ==="
curl -fsSL https://tailscale.com/install.sh | sh

echo "=== Checking auth key ==="

if [ "$TAILSCALE_AUTHKEY" = "xyz-REPLACE-ME" ] || [ -z "$TAILSCALE_AUTHKEY" ]; then
  echo "ERROR: You must replace TAILSCALE_AUTHKEY in the script"
  exit 1
fi

echo "=== Connecting to Tailscale ==="
su -c "tailscale up --authkey=$TAILSCALE_AUTHKEY"

echo "=== DONE ==="
echo "SSH + Tailscale setup complete"
