#!/bin/bash
# bash -c "$(wget -qLO- https://raw.githubusercontent.com/therepos/kasm-images/main/setup-sharedmount.sh?$(date +%s))"
# Setup shared media mount from Proxmox host to VM

set -e

# Defaults (edit these or pass as arguments)
HOST_IP="${1:-192.168.1.111}"           # replace hostIP e.g. 192.168.1.100  
SHARE_NAME="${2:-mediadb}"              # shared folder
MOUNT_PATH="${3:-/mnt/sec/media}"       # path to shared folder
SMB_USER="${4:-username}"               # samba username
SMB_PASS="${5:-password}"               # samba password

echo "=== Shared Mount Setup ==="
echo "Host IP:    $HOST_IP"
echo "Share:      $SHARE_NAME"
echo "Mount at:   $MOUNT_PATH"
echo "SMB User:   $SMB_USER"
echo ""

# Install cifs-utils if not present
if ! dpkg -s cifs-utils &>/dev/null; then
    echo "Installing cifs-utils..."
    sudo apt update && sudo apt install -y cifs-utils
else
    echo "cifs-utils already installed"
fi

# Create mount point
sudo mkdir -p "$MOUNT_PATH"

# Unmount if already mounted
if mountpoint -q "$MOUNT_PATH" 2>/dev/null; then
    echo "Unmounting existing mount..."
    sudo umount "$MOUNT_PATH"
fi

# Mount the share with proper permissions (uid/gid 1000 for container access)
echo "Mounting //$HOST_IP/$SHARE_NAME to $MOUNT_PATH..."
sudo mount -t cifs "//$HOST_IP/$SHARE_NAME" "$MOUNT_PATH" \
    -o username="$SMB_USER",password="$SMB_PASS",uid=1000,gid=1000,file_mode=0777,dir_mode=0777

# Verify mount
if mountpoint -q "$MOUNT_PATH"; then
    echo "Mount successful!"
    ls "$MOUNT_PATH" | head -10
else
    echo "ERROR: Mount failed"
    exit 1
fi

# Add to fstab if not already there
FSTAB_ENTRY="//$HOST_IP/$SHARE_NAME $MOUNT_PATH cifs username=$SMB_USER,password=$SMB_PASS,uid=1000,gid=1000,file_mode=0777,dir_mode=0777,_netdev 0 0"

if grep -qF "//$HOST_IP/$SHARE_NAME" /etc/fstab; then
    echo "Updating existing fstab entry..."
    sudo sed -i "\|//$HOST_IP/$SHARE_NAME|c\\$FSTAB_ENTRY" /etc/fstab
else
    echo "Adding to fstab for persistence..."
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
fi

sudo systemctl daemon-reload

echo ""
echo "=== Done ==="
echo "Mount: //$HOST_IP/$SHARE_NAME -> $MOUNT_PATH"
echo "Persisted in /etc/fstab"
echo "Container volume: $MOUNT_PATH/shared:/home/kasm-user/Downloads"