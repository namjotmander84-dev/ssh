#!/bin/bash

set -e

# =========================
# CONFIG (replace this)
# =========================
TAILSCALE_AUTHKEY="tskey-auth-k9jqhnFtph11CNTRL-FvkmeFS1FrFd7oEffMw1rFfuU8ohDu8oX"

echo "=== Installing required packages ==="
dnf install -y openssh-server curl

echo "=== Preparing SSH keys ==="
ssh-keygen -A

echo "=== Configuring SSH port to 9000 ==="
sed -i 's/#Port 22/Port 9000/' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 9000/' /etc/ssh/sshd_config

echo "=== Starting SSH manually (no systemd) ==="
sshd

echo "=== Installing Tailscale ==="
curl -fsSL https://tailscale.com/install.sh | sh

echo "=== Checking auth key ==="
if [ "$TAILSCALE_AUTHKEY" = "xyz-REPLACE-ME" ]; then
  echo "ERROR: Replace TAILSCALE_AUTHKEY in script"
  exit 1
fi

echo "=== Starting Tailscale ==="
tailscaled --state=/var/lib/tailscale/tailscaled.state &
sleep 2
tailscale up --authkey=$TAILSCALE_AUTHKEY

echo "=== DONE ==="
echo "SSH running on port 9000"
echo "Tailscale connected"
