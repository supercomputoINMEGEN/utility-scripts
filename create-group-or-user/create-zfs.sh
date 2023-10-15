#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 -zfsdir <directory-name for zfs share>  -quota <quota>" 
  exit 1
}

# Parse command-line options using getopts
while getopts ":zfsdir:quota:" opt; do
  case "$opt" in
    zfsdir)
      zfsdir_name="$OPTARG"
      ;;
    quota)
      quota="$OPTARG"
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

# Check if the required any argument is missing
if [ -zfsdir "$zfsdir_name" ] || [ -quota "$quota" ]; then
  echo "Error: Both -zfsdir and -quota are required."
  usage
fi

# Check if the ZFS directory already exists
if zfs list | grep -q -w "$zfsdir_name"; then
  echo "Error: ZFS directory '$zfsdir_name' already exists."
  exit 1
fi

# Create the ZFS directory
zfs set quota="$quota" "$zfsdir_name"
if [ $? -eq 0 ]; then
  echo "ZFS directory '$zfsdir_name' created successfully."
else
  echo "Error: Failed to create ZFS directory '$zfsdir_name'."
  exit 1
fi
