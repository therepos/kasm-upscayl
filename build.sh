#!/bin/bash
set -e

IMAGE_NAME="ghcr.io/therepos/kasm-upscayl"
KASM_VERSION="${1:-1.17.0}"

echo "============================================"
echo "  Building kasm-upscayl:${KASM_VERSION}"
echo "============================================"

docker build \
  --build-arg KASM_VERSION="${KASM_VERSION}" \
  -t "${IMAGE_NAME}:${KASM_VERSION}" \
  -t "${IMAGE_NAME}:latest" \
  .

echo ""
echo "============================================"
echo "  Build complete!"
echo "============================================"
echo ""
echo "  Image: ${IMAGE_NAME}:${KASM_VERSION}"
echo ""
echo "  To push to GHCR:"
echo "    docker push ${IMAGE_NAME}:${KASM_VERSION}"
echo "    docker push ${IMAGE_NAME}:latest"
echo ""
echo "  To register in Kasm Admin:"
echo "    Docker Image:  ${IMAGE_NAME}:${KASM_VERSION}"
echo "    GPU Count:     1"
echo "    Docker Run Config Override:"
echo '    {"environment":{"NVIDIA_DRIVER_CAPABILITIES":"all","NVIDIA_VISIBLE_DEVICES":"all"}}'
echo ""
