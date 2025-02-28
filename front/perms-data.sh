#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo
echo ---
echo Set permissions for $this_file_dir/../data/front
echo ---
echo

# Ownership and permissions for already existing folders are set recursively by the script in parent folder.
# Each new folder in the hierarchy created separately to make sure all of them will have proper permissions set.

if [ -d "$this_file_dir/../data/front" ]; then
    ls -la $this_file_dir/../data/front
fi

mkdir -p -m ugo+rwx $this_file_dir/../data
mkdir -p -m ugo+rwx $this_file_dir/../data/front
mkdir -p -m ugo+rwx $this_file_dir/../data/front/traefik
mkdir -p -m ugo+rwx $this_file_dir/../data/front/traefik/acme

# The ACME resolver \"myresolver\" is skipped from the resolvers list because: 
# unable to get ACME account: permissions 660 for /etc/traefik/acme/acme.json are too open, please use 600

if [ -f "$this_file_dir/../data/front/traefik/acme/acme.json" ]; then
    chmod u=rw,go= $this_file_dir/../data/front/traefik/acme/acme.json
fi

ls -la $this_file_dir/../data/front
