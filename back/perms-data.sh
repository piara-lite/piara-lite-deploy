#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo
echo ---
echo Set permissions for $this_file_dir/../data/back
echo ---
echo

# Ownership and permissions for already existing folders are set recursively by the script in parent folder.
# Each new folder in the hierarchy created separately to make sure all of them will have proper permissions set.

if [ -d "$this_file_dir/../data/back" ]; then
    ls -la $this_file_dir/../data/back
fi

mkdir -p -m ugo+rwx $this_file_dir/../data
mkdir -p -m ugo+rwx $this_file_dir/../data/back
mkdir -p -m ugo+rwx $this_file_dir/../data/back/db
mkdir -p -m ugo+rwx $this_file_dir/../data/back/db/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-maintenance
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-maintenance/logs
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-maintenance/logs/background_jobs
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-maintenance/logs/indexation
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server/files
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server/reports
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server/tessdata
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-core
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-core/logs
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-core/logs/background_jobs
mkdir -p -m ugo+rwx $this_file_dir/../data/back/server-core/logs/indexation
mkdir -p -m ugo+rwx $this_file_dir/../data/back/zoo
mkdir -p -m ugo+rwx $this_file_dir/../data/back/zoo/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/kafka
mkdir -p -m ugo+rwx $this_file_dir/../data/back/kafka/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/redis
mkdir -p -m ugo+rwx $this_file_dir/../data/back/redis/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/es
mkdir -p -m ugo+rwx $this_file_dir/../data/back/es/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/es/logs
mkdir -p -m ugo+rwx $this_file_dir/../data/back/wickrio
mkdir -p -m ugo+rwx $this_file_dir/../data/back/wickrio/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/arangodb
mkdir -p -m ugo+rwx $this_file_dir/../data/back/arangodb/data
mkdir -p -m ugo+rwx $this_file_dir/../data/back/traefik
mkdir -p -m ugo+rwx $this_file_dir/../data/back/traefik/acme
mkdir -p -m ugo+rwx $this_file_dir/../data/back/ollama

# The ACME resolver \"myresolver\" is skipped from the resolvers list because: 
# unable to get ACME account: permissions 660 for /etc/traefik/acme/acme.json are too open, please use 600
if [ -f "$this_file_dir/../data/back/traefik/acme/acme.json" ]; then
    chmod u=rw,go= $this_file_dir/../data/back/traefik/acme/acme.json
fi

ls -la $this_file_dir/../data/back
