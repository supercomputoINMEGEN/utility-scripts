#!/bin/bash

# Function to display script usage
usage() {
  echo "Usage: $0 -G <numeric> -g <text> -c <yes|no> [-z <text>] [-q <text>] [-m <text>]"
  echo "  -G <numeric>      GID of the group (not optional)."
  echo "  -g <text>         Group name (not optional)."
  echo "  -c <yes|no>       ZFS creation flag (not optional)."
  echo "  -z <text>         ZFS name (optional)."
  echo "  -q <text>         Quota (optional)."
  echo "  -m <text>         Mountpoint (optional)."
  exit 1
}

# Define default values for optional arguments
zfs_create="no"
zfs_name=""
quota=""
mountpoint=""

# Parse the command-line arguments
while getopts ":G:g:c:z:q:m:" opt; do
  case $opt in
    G)
      gid="$OPTARG"
      ;;
    g)
      group_name="$OPTARG"
      ;;
    c)
      zfs_create="$OPTARG"
      ;;
    z)
      zfs_name="$OPTARG"
      ;;
    q)
      quota="$OPTARG"
      ;;
    m)
      mountpoint="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Check if the GID is already used by a group
if getent group "$gid" > /dev/null; then
  echo "Error: GID $gid is already in use by another group."
  exit 1
fi

# Check if the group name is already used by a group
if getent group "$group_name" > /dev/null; then
  echo "Error: Group name '$group_name' is already in use by another group."
  exit 1
fi

# If zfs-create is "yes," call create-zfs.sh script with -z, -q, and -m arguments
if [ "$zfs_create" = "yes" ]; then
  if [ -n "$zfs_name" ] && [ -n "$quota" ] && [ -n "$mountpoint" ]; then
    ./create-zfs.sh -z "$zfs_name" -q "$quota" -m "$mountpoint"
    # Change the owner group of the mountpoint to the group name
    if [ -n "$mountpoint" ]; then
      chown -R :"$group_name" "$mountpoint"
    fi
  else
    echo "Error: Missing arguments for ZFS creation."
    usage
  fi
fi

# Create the group with the given GID and name
groupadd -g "$gid" "$group_name" \
&& echo "Group creation and ZFS setup (if applicable) completed successfully."
