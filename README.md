## Usage

1. Requires NVIDIA GPU with drivers and NVIDA Container Toolkit.
2. Docker pull `ghcr.io/therepos/kasm-images/upscayl:latest`.
3. Deploy docker compose via portainer stack.

## Structure

```
kasm-upscayl/
├── .github/
│   └── workflows/
│       └── build.yml
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── LICENSE
├── README.md
└── setup-sharedmount.sh
```

## Resources

- [Upscayl](https://upscayl.org/)


<!-- | Image | Description | GHCR |
|---|---|---|
| **upscayl** |  () | `ghcr.io/therepos/kasm-images/upscayl:1.17.0` |
| **comfyui** | Node-based AI image generation ([ComfyUI](https://github.com/comfyanonymous/ComfyUI)) | `ghcr.io/therepos/kasm-images/comfyui:1.17.0` |
| **iopaint** | AI inpainting/outpainting tool (coming soon) | — | -->

