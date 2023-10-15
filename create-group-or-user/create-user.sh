#!/bin/bash

# Define a usage function
usage() {
  echo "Usage: $0 -G <group_name> -i <UID> -u <username> -d <expire_date> -s <yes/no> -c <yes/no> [-z <zfs_name>] [-q <quota>] [-m <mountpoint>]"
  exit 1
}

# Parse the options
while getopts "G:i:u:d:s:c:z:q:m:" opt; do
  case $opt in
    G)
      group_name="$OPTARG"
      ;;
    i)
      UID="$OPTARG"
      ;;
    u)
      username="$OPTARG"
      ;;
    d)
      expire_date="$OPTARG"
      ;;
    s)
      shell_flag="$OPTARG"
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
  esac
done

# Check if required options are provided
if [ -z "$group_name" ] || [ -z "$UID" ] || [ -z "$username" ] || [ -z "$expire_date" ] || [ -z "$shell_flag" ] || [ -z "$zfs_create" ]; then
  echo "Missing required options."
  usage
fi

# Check if UID is already used
if id "$UID" &>/dev/null; then
  echo "UID $UID is already in use."
  exit 1
fi

# Check if username is already used
if id "$username" &>/dev/null; then
  echo "Username $username is already in use."
  exit 1
fi

# define the shell to use
if [ "$shell_flag" == "yes" ]; then
  the_shell="/bin/bash"
else
  the_shell="/sbin/nologin"
fi

# Check if zfs-create argument is "yes"
if [ "$zfs_create" == "yes" ]; then
  # Call create-zfs.sh script with -z, -q, and -m arguments
  if [ -n "$zfs_name" ]; then
    ./create-zfs.sh -z "$zfs_name" -q "$quota" -m "$mountpoint"
  fi

  # Change owner user:group in the mountpoint to username
  if [ -n "$mountpoint" ]; then
    chown "$username:$username" "$mountpoint"
  fi
fi

useradd \
  -g "$group_name" \
  -u "$UID" \
  -d "$mountpoint" \
  -s "$the_shell" \
  -e "$expire_date" \
  "$username" \
&& echo "User $username created successfully."

