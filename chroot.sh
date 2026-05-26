#!/bin/bash

set -e

# =========================
# CONFIG (replace this)
# =========================
TAILSCALE_AUTHKEY="tskey-auth-k9jqhnFtph11CNTRL-FvkmeFS1FrFd7oEffMw1rFfuU8ohDu8oX"

echo "=== STEP 1: Fix curl conflict ==="
dnf swap -y curl-minimal curl || dnf install -y curl --allowerasing

#echo "=== STEP 2: Install SSH server ==="
#dnf install -y openssh-server

echo "=== STEP 3: Generate SSH keys ==="
ssh-keygen -A

echo "=== STEP 4: Configure SSH port 9000 ==="
mkdir -p /etc/ssh
sed -i 's/#Port 22/Port 9000/' /etc/ssh/sshd_config 2>/dev/null || true
sed -i 's/Port 22/Port 9000/' /etc/ssh/sshd_config 2>/dev/null || true

echo "=== STEP 5: Start SSH manually ==="
sshd /usr/sbin/sshd -D

echo "=== STEP 6: Install Tailscale ==="
curl -fsSL https://tailscale.com/install.sh | sh

echo "=== STEP 7: Validate auth key ==="
if [ "$TAILSCALE_AUTHKEY" = "xyz-REPLACE-ME" ]; then
  echo "ERROR: Replace TAILSCALE_AUTHKEY in script"
  exit 1
fi

echo "=== STEP 8: Start Tailscale daemon ==="
tailscaled --state=/var/lib/tailscale.state &
sleep 2

tailscale up --authkey=$TAILSCALE_AUTHKEY

echo "=== DONE ==="
echo "SSH running on port 9000"
echo "Tailscale connected"

