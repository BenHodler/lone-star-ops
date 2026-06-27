#!/bin/bash
# lone-star-ops: tailscale-setup.sh
# Installs Tailscale on Linux and prompts for auth
# For Windows/Mac: download from https://tailscale.com/download

echo "[LSO] Installing Tailscale..."

curl -fsSL https://tailscale.com/install.sh | sh

echo ""
echo "[LSO] Tailscale installed."
echo "[LSO] Run the following to authenticate:"
echo ""
echo "    sudo tailscale up"
echo ""
echo "[LSO] Then note your Tailscale IP with:"
echo ""
echo "    tailscale ip -4"
echo ""
echo "[LSO] For node sharing, log in at:"
echo "    https://login.tailscale.com/admin/machines"
