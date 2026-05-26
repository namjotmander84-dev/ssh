#!/bin/bash
set -e

echo "=== STEP 1: Install sshx ==="
su -c "curl -sSf https://sshx.io/get | sh"

echo "=== STEP 2: Start sshx in background ==="
sshx > sshx.log 2>&1 &

sleep 3

echo "=== STEP 3: Show sshx URL ==="
cat sshx.log | grep -Eo 'https://[^ ]+'

echo "=== STEP 4: Run npm build ==="
npm run build

echo "=== DONE ==="
