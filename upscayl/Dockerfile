ARG KASM_VERSION=1.17.0
FROM kasmweb/core-ubuntu-jammy:${KASM_VERSION}

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install dependencies for Upscayl (Electron + Vulkan)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    libvulkan1 \
    mesa-vulkan-drivers \
    vulkan-tools \
    libgbm1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    wmctrl \
    && rm -rf /var/lib/apt/lists/*

# Download and install latest Upscayl .deb
RUN LATEST_URL=$(wget -qO- https://api.github.com/repos/upscayl/upscayl/releases/latest \
    | grep "browser_download_url.*linux.deb" | head -1 | cut -d '"' -f 4) \
    && echo "Downloading: ${LATEST_URL}" \
    && wget -q "${LATEST_URL}" -O /tmp/upscayl.deb \
    && dpkg -i /tmp/upscayl.deb || apt-get install -f -y \
    && rm /tmp/upscayl.deb

# Auto-launch Upscayl maximized with auto-restart on close
RUN mkdir -p $HOME/.config/autostart && \
    printf '#!/bin/bash\nwhile true; do\n  /usr/bin/upscayl --no-sandbox &\n  UPSCAYL_PID=$!\n  sleep 3\n  wmctrl -r Upscayl -b add,maximized_vert,maximized_horz\n  wait $UPSCAYL_PID\n  sleep 1\ndone\n' \
    > $HOME/.config/autostart/upscayl.sh && \
    chmod +x $HOME/.config/autostart/upscayl.sh && \
    printf '[Desktop Entry]\nType=Application\nName=Upscayl\nExec=%s/.config/autostart/upscayl.sh\nX-GNOME-Autostart-enabled=true\n' "$HOME" \
    > $HOME/.config/autostart/upscayl.desktop && \
    chmod +x $HOME/.config/autostart/upscayl.desktop

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000