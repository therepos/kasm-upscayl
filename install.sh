#!/bin/bash
set -e

# ============================================
#  kasm-upscayl installer
#  One-liner: bash <(wget -qO- https://raw.githubusercontent.com/therepos/kasm-upscayl/main/install.sh)
# ============================================

IMAGE="ghcr.io/therepos/kasm-upscayl"
TAG="${1:-latest}"

echo ""
echo "============================================"
echo "  kasm-upscayl installer"
echo "============================================"
echo ""

# Check prerequisites
echo "[1/3] Checking prerequisites..."

if ! command -v docker &> /dev/null; then
  echo "  ERROR: Docker is not installed."
  exit 1
fi

if ! nvidia-smi &> /dev/null; then
  echo "  WARNING: nvidia-smi not found. GPU may not work."
fi

if ! docker system info 2>/dev/null | grep -q nvidia; then
  echo "  WARNING: NVIDIA runtime not found in Docker."
  echo "  Install NVIDIA Container Toolkit first."
fi

echo "  OK"

# Pull the image
echo "[2/3] Pulling ${IMAGE}:${TAG}..."
docker pull "${IMAGE}:${TAG}"

echo "  OK"

# Print registration instructions
echo "[3/3] Done!"
echo ""
echo "============================================"
echo "  Register in Kasm Admin"
echo "============================================"
echo ""
echo "  1. Log into Kasm Admin panel"
echo "  2. Go to: Admin > Workspaces > Add Workspace"
echo "  3. Fill in:"
echo ""
echo "     Friendly Name:   Upscayl"
echo "     Docker Image:    ${IMAGE}:${TAG}"
echo "     Cores:           4"
echo "     Memory (MB):     4096"
echo "     GPU Count:       1"
echo ""
echo "  4. In 'Docker Run Config Override (JSON)':"
echo ""
echo '     {"environment":{"NVIDIA_DRIVER_CAPABILITIES":"all","NVIDIA_VISIBLE_DEVICES":"all"}}'
echo ""
echo "  5. Click Save, then launch from Dashboard."
echo ""
