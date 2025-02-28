#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
[ -e $this_file_dir/.env ] && export $(cat $this_file_dir/.env | xargs -d '\n')

echo "Configuring all services..."
$this_file_dir/config-common.sh

echo "Starting the stack..."
$this_file_dir/up.sh

echo "List docker containers..."
docker ps -a

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
[ -e $this_file_dir/.env ] && export $(cat $this_file_dir/.env | xargs -d '\n')

echo "List docker stack services..."
docker stack services ${PIARA_COMMON_STACK_NAME}

echo "=== DEPLOYMENT SCRIPT END ==="
