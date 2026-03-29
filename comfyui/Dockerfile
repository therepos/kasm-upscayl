ARG KASM_VERSION=1.17.0
FROM kasmweb/core-ubuntu-jammy:${KASM_VERSION}

USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Allow pip to install into system site-packages (works with any pip version)
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install Python 3.11, pip, git, and GPU/system dependencies
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
    wmctrl \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip itself first
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

# Create symlink so models/outputs persist via volume mount
RUN mkdir -p $HOME/Downloads/comfyui-data/models \
             $HOME/Downloads/comfyui-data/output \
             $HOME/Downloads/comfyui-data/input \
    && ln -sf $HOME/Downloads/comfyui-data/output /opt/comfyui/output \
    && ln -sf $HOME/Downloads/comfyui-data/input  /opt/comfyui/input

# Auto-launch ComfyUI server + browser on session start
RUN mkdir -p $HOME/.config/autostart && \
    printf '#!/bin/bash\n\
# Start ComfyUI server in background\n\
cd /opt/comfyui\n\
python3 main.py --listen 0.0.0.0 --port 8188 --preview-method auto \\\n\
  --output-directory /home/kasm-user/Downloads/comfyui-data/output \\\n\
  --input-directory /home/kasm-user/Downloads/comfyui-data/input \\\n\
  &\n\
COMFY_PID=$!\n\
\n\
# Wait for server to be ready\n\
for i in $(seq 1 60); do\n\
  if curl -s http://127.0.0.1:8188/ >/dev/null 2>&1; then\n\
    break\n\
  fi\n\
  sleep 2\n\
done\n\
\n\
# Launch browser maximized\n\
while true; do\n\
  /usr/bin/chromium --no-sandbox --disable-gpu-compositing \\\n\
    --start-maximized --app=http://127.0.0.1:8188 &\n\
  BROWSER_PID=$!\n\
  sleep 2\n\
  wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz 2>/dev/null || true\n\
  wait $BROWSER_PID\n\
  sleep 1\n\
done\n' \
    > $HOME/.config/autostart/comfyui.sh && \
    chmod +x $HOME/.config/autostart/comfyui.sh && \
    printf '[Desktop Entry]\nType=Application\nName=ComfyUI\nExec=%s/.config/autostart/comfyui.sh\nX-GNOME-Autostart-enabled=true\n' "$HOME" \
    > $HOME/.config/autostart/comfyui.desktop && \
    chmod +x $HOME/.config/autostart/comfyui.desktop

# Ensure chromium is available (Kasm core ships it, but verify)
RUN which chromium || which chromium-browser || \
    (apt-get update && apt-get install -y --no-install-recommends chromium-browser && rm -rf /var/lib/apt/lists/*)

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000