#!/bin/bash

# Define a usage function
usage() {
  echo "Usage: $0 -G <group_name> -i <user_UID> -u <username> -d <expire_date> -s <yes/no> -c <yes/no> [-z <zfs_name>] [-q <quota>] [-m <mountpoint>]"
  exit 1
}

# Parse the options
while getopts "G:i:u:d:s:c:z:q:m:" opt; do
  case $opt in
    G)
      group_name="$OPTARG"
      ;;
    i)
      user_UID="$OPTARG"
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
if [ -z "$group_name" ] || [ -z "$user_UID" ] || [ -z "$username" ] || [ -z "$expire_date" ] || [ -z "$shell_flag" ] || [ -z "$zfs_create" ]; then
  echo "Missing required options."
  usage
fi

# Check if user_UID is already used
if id "$user_UID" &>/dev/null; then
  echo "user_UID $user_UID is already in use."
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
    bash ./create-zfs.sh -z "$zfs_name" -q "$quota" -m "$mountpoint"
fi

useradd \
  -g "$group_name" \
  -u "$user_UID" \
  -d "$mountpoint" \
  -s "$the_shell" \
  -e "$expire_date" \
  "$username" \
&& sudo cp -r /etc/skel/. "$mountpoint" \
&& sudo chmod 750 "$mountpoint" \
&& printf "hola${_NEWUSER}\nhola${_NEWUSER}\n" | sudo passwd "${_NEWUSER}" \
&& sudo passwd -e "${_NEWUSER}" \
&& chown -R "$username" "$mountpoint" \
&& echo "User $username created successfully."
