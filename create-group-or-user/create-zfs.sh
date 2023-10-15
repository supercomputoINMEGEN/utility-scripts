#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 -z <directory-name for zfs share>"
  exit 1
}

# Parse command-line options using getopts
while getopts ":z:" opt; do
  case "$opt" in
    z)
      zfsdir_name="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
  esac
done

# Check if the required -z argument is missing
if [ -z "$zfsdir_name" ]; then
  echo "Error: -z is required."
  usage
fi

# Check if the ZFS directory already exists
if zfs list | grep -q "$zfsdir_name"; then
  echo "Error: ZFS directory '$zfsdir_name' already exists."
  exit 1
fi

# Create the ZFS directory
zfs create "$zfsdir_name"
if [ $? -eq 0 ]; then
  echo "ZFS directory '$zfsdir_name' created successfully."
else
  echo "Error: Failed to create ZFS directory '$zfsdir_name'."
fi
