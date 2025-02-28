#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo
echo ---
echo Set permissions for $this_file_dir
echo ---
echo

# Ownership and permissions for already existing folders are set recursively by the script in parent folder.
# Each new folder in the hierarchy created separately to make sure all of them will have proper permissions set.

ls -la $this_file_dir

chmod -R ugo+rw $this_file_dir/grafana

ls -la $this_file_dir
