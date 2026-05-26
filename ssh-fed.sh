#!/bin/bash

set -e

# =========================
# CONFIG (replace this)
# =========================
TAILSCALE_AUTHKEY="tskey-auth-k9jqhnFtph11CNTRL-FvkmeFS1FrFd7oEffMw1rFfuU8ohDu8oX"

echo "=== Updating system ==="
su -c "dnf update -y"

echo "=== Installing SSH server ==="
su -c "dnf install -y openssh-server"

su -c "systemctl enable sshd"
su -c "systemctl start sshd"

echo "=== Installing Tailscale ==="
curl -fsSL https://tailscale.com/install.sh | sh

echo "=== Checking auth key ==="
if [ "$TAILSCALE_AUTHKEY" = "xyz-REPLACE-ME" ]; then
  echo "ERROR: Replace TAILSCALE_AUTHKEY in script"
  exit 1
fi

echo "=== Starting Tailscale ==="
su -c "tailscale up --authkey=$TAILSCALE_AUTHKEY"

echo "=== DONE ==="
echo "SSH + Tailscale is ready"
