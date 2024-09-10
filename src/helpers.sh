#!/bin/bash

# environment variables must have been set before executing the script !
#set -a
#. ./homekube.env.sh
#set +a

# check if specified persistent storage is available and can be mounted
function checkmount {
  apt install nfs-common -y
  mountpoint="/mnt/${HOMEKUBE_DOMAIN_DASHED}"
  device="${HOMEKUBE_NFS_SERVER_URL}:${HOMEKUBE_NFS_SERVER_PATH}"
  echo "Checking for specified path ${HOMEKUBE_NFS_SERVER_PATH} on ${HOMEKUBE_NFS_SERVER_URL} "
  if mount | grep -q "$mountpoint"; then
    echo "The mountpoint already exists. Make sure to not overwrite another installation"
    exit 1
  else
    sudo mount -t nfs $device $mountpoint
    if [[ $? -ne 0 ]]; then
        echo "The specified path cannot be mounted. Make sure that it exists and has proper rights"
        exit 1
    fi
  fi
  sudo umount $mountpoint
}
