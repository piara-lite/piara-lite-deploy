#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PIARA_USER='root'
PIARA_GROUP='sudo'

echo
echo ---
echo Set permissions for $this_file_dir
echo ---
echo

# Define color variables
RED="\033[31m"
RESET="\033[0m"

echo -e "${RED}"  # Set text color to red
echo This script will update permissions inside \'data\' folder.
echo Make sure that all stacks who persist data in this folder are DOWN.
echo Otherwise data may be corrupted. This especially concerns database services!

read -p "Are you sure to continue? (y/n) " -n 1 -r

echo -e "${RESET}"  # Reset the color to default

echo # (optional) move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo Going to set permissions now.
else
    echo Exiting.
    exit 1
fi

mkdir -p -m ugo+rwx $this_file_dir/data

ls -la $this_file_dir/data

# For data folder only, and inside of it.
#find $this_file_dir/data -exec chown ${PIARA_USER}:${PIARA_GROUP} {} \;
chown -R ${PIARA_USER}:${PIARA_GROUP} $this_file_dir/data

# For data folder only, and inside of it.
find $this_file_dir/data -type d -exec chmod ugo=rwx {} \;

# For data folder only, and inside of it.
find $this_file_dir/data -type f -exec chmod ugo=rw {} \;

ls -la $this_file_dir/data

if [ -f "$this_file_dir/back/perms-data.sh" ]; then $this_file_dir/back/perms-data.sh; fi
if [ -f "$this_file_dir/front/perms-data.sh" ]; then $this_file_dir/front/perms-data.sh; fi
