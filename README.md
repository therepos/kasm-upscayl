# kasm-images

Pre-built [Kasm Workspace](https://kasm.com/) images with NVIDIA GPU support, automatically built and published to GHCR.

## Images

| Image | Description | GHCR |
|---|---|---|
| **upscayl** | AI image upscaler ([Upscayl](https://upscayl.org/)) | `ghcr.io/therepos/kasm-images/upscayl:1.17.0` |
| **comfyui** | Node-based AI image generation ([ComfyUI](https://github.com/comfyanonymous/ComfyUI)) | `ghcr.io/therepos/kasm-images/comfyui:1.17.0` |
| **iopaint** | AI inpainting/outpainting tool (coming soon) | — |

## Prerequisites

- Kasm Workspaces 1.17.0 on Ubuntu
- NVIDIA GPU with drivers installed on the host
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) configured for Docker

## Usage

### 1. Pull the image

```bash
docker pull ghcr.io/therepos/kasm-images/upscayl:1.17.0
docker pull ghcr.io/therepos/kasm-images/comfyui:1.17.0
```

### 2. Register in Kasm Admin

1. Go to **Admin → Workspaces → Add Workspace**
2. Fill in:

#### Upscayl

| Field | Value |
|---|---|
| Friendly Name | `Upscayl` |
| Docker Image | `ghcr.io/therepos/kasm-images/upscayl:1.17.0` |
| Cores | `4` |
| Memory (MB) | `4096` |
| GPU Count | `1` |

#### ComfyUI

| Field | Value |
|---|---|
| Friendly Name | `ComfyUI` |
| Docker Image | `ghcr.io/therepos/kasm-images/comfyui:1.17.0` |
| Cores | `4` |
| Memory (MB) | `8192` |
| GPU Count | `1` |

3. Set **Docker Run Config Override (JSON)**:

```json
{
  "environment": {
    "NVIDIA_DRIVER_CAPABILITIES": "all",
    "NVIDIA_VISIBLE_DEVICES": "all"
  }
}
```

4. Click **Save**, then launch from the Dashboard.

## ComfyUI Notes

- **Models**: Place models in the shared mount at `Downloads/comfyui-data/models/` or use ComfyUI Manager to download them from within the session.
- **Outputs**: Generated images are saved to `Downloads/comfyui-data/output/` (persisted via volume mount).
- **Port 8188**: Also exposed directly if you want to access ComfyUI outside the Kasm desktop session.
- **shm_size**: Set to 2g (vs 512m for Upscayl) because PyTorch uses shared memory for data loading.

## Automated Builds

GitHub Actions rebuilds all images:

- On every push to `main` that changes a Dockerfile
- Weekly (Sunday 03:00 UTC) to pick up upstream updates
- On manual trigger via `workflow_dispatch` (build one or all)

## Adding a New Image

1. Create a new directory: `mkdir myapp`
2. Add a `Dockerfile` based on `kasmweb/core-ubuntu-jammy`
3. Push to `main` — GitHub Actions builds and publishes it automatically

## Troubleshooting

### Black screen on launch

Add DRI devices to Docker Run Config Override:

```json
{
  "environment": {
    "NVIDIA_DRIVER_CAPABILITIES": "all",
    "NVIDIA_VISIBLE_DEVICES": "all"
  },
  "devices": [
    "/dev/dri/card0:/dev/dri/card0:rwm",
    "/dev/dri/renderD128:/dev/dri/renderD128:rwm"
  ]
}
```

### App won't start

Electron apps need `--no-sandbox` inside containers (already set in desktop shortcuts).

### GPU not detected in session

```bash
nvidia-smi
vulkaninfo --summary
```

If these fail, check Proxmox GPU passthrough (IOMMU, vfio-pci) and NVIDIA Container Toolkit.

### ComfyUI slow or OOM

- Increase `shm_size` in docker-compose (e.g., `4g`)
- Increase Kasm workspace memory allocation
- Use fp16 checkpoints instead of fp32 to halve VRAM usage

## License

MIT
