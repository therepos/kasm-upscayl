# kasm-upscayl

A pre-built [Kasm Workspace](https://kasm.com/) image with [Upscayl](https://upscayl.org/) — the open-source AI image upscaler — with NVIDIA GPU support.

## Quick Start

On your Kasm host, run:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/therepos/kasm-upscayl/main/install.sh)
```

This pulls the pre-built image from GHCR and gives you the Kasm registration instructions.

## What's Included

- **Base:** `kasmweb/core-ubuntu-jammy:1.17.0`
- **Upscayl:** Latest release (auto-fetched at build time)
- **GPU deps:** Vulkan drivers, mesa, NVIDIA runtime support
- **Desktop shortcut:** Launches Upscayl on session start

## Prerequisites

- Kasm Workspaces 1.17.0 running on Ubuntu
- NVIDIA GPU with drivers installed on the host
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) configured for Docker

## Manual Setup

### Option A: Pull from GHCR (recommended)

```bash
docker pull ghcr.io/therepos/kasm-upscayl:1.17.0
```

Then register in Kasm Admin:

| Field | Value |
|---|---|
| Friendly Name | `Upscayl` |
| Docker Image | `ghcr.io/therepos/kasm-upscayl:1.17.0` |
| Cores | `4` |
| Memory (MB) | `4096` |
| GPU Count | `1` |

Docker Run Config Override:

```json
{"environment":{"NVIDIA_DRIVER_CAPABILITIES":"all","NVIDIA_VISIBLE_DEVICES":"all"}}
```

### Option B: Build locally

```bash
git clone https://github.com/therepos/kasm-upscayl.git
cd kasm-upscayl
sudo ./build.sh 1.17.0
```

## Upgrading Kasm Version

If you upgrade Kasm to a newer version (e.g., 1.18.0):

```bash
# Local build
sudo ./build.sh 1.18.0

# Or trigger GitHub Actions with a different version
# via workflow_dispatch in the Actions tab
```

## Automated Builds

GitHub Actions rebuilds the image:

- On every push to `main`
- Weekly (Sunday 03:00 UTC) to pick up new Upscayl releases
- On manual trigger via `workflow_dispatch`

## Troubleshooting

### Black screen on launch

Add DRI devices to the Docker Run Config Override:

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

### Upscayl won't start

Ensure `--no-sandbox` is in the Exec command (already set in the desktop shortcut). Electron apps require this inside containers.

### "No Vulkan GPU found"

Verify GPU access inside the Kasm session terminal:

```bash
nvidia-smi
vulkaninfo --summary
```

If these fail, check your Proxmox GPU passthrough (IOMMU, vfio-pci) and NVIDIA Container Toolkit setup.

## License

MIT
