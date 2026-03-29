FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install Python 3.11 and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3-pip \
    git \
    wget \
    curl \
    ca-certificates \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    ffmpeg \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /opt/comfyui

# Install PyTorch (CUDA 12.1) and ComfyUI dependencies
RUN python3 -m pip install --no-cache-dir \
    torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 \
    && python3 -m pip install --no-cache-dir \
    -r /opt/comfyui/requirements.txt

# Install ComfyUI Manager
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git \
    /opt/comfyui/custom_nodes/ComfyUI-Manager

# Create data directories for volume mounting
RUN mkdir -p /data/models /data/output /data/input \
    && ln -sf /data/output /opt/comfyui/output \
    && ln -sf /data/input  /opt/comfyui/input

WORKDIR /opt/comfyui
EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--preview-method", "auto"]