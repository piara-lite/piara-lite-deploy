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

ls -la $this_file_dir

# Including this file folder, excluding data folder and .git folder.
find $this_file_dir -not -path "$this_file_dir/data/*" -not -path "$this_file_dir/.git/*" -exec chown ${PIARA_USER}:${PIARA_GROUP} {} \;

# Including this file folder, excluding data folder and .git folder.
find $this_file_dir -type d -not -path "$this_file_dir/data/*" -not -path "$this_file_dir/.git/*" -exec chmod ug=rwx,o=x {} \;

# Excluding data folder and .git folder.
find $this_file_dir -type f -not -path "$this_file_dir/data/*" -not -path "$this_file_dir/.git/*" -exec chmod ug=rw,o= {} \;

# Excluding data folder and .git folder.
find $this_file_dir -maxdepth 3 -type f -iname '*.sh' -not -path "$this_file_dir/data/*" -not -path "$this_file_dir/.git/*" -exec chmod ug+x {} \;

ls -la $this_file_dir

if [ -f "$this_file_dir/back/perms.sh" ]; then $this_file_dir/back/perms.sh; fi
if [ -f "$this_file_dir/front/perms.sh" ]; then $this_file_dir/front/perms.sh; fi
if [ -f "$this_file_dir/prometheus/perms.sh" ]; then $this_file_dir/prometheus/perms.sh; fi
