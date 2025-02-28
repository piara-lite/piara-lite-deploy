#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
[ -e $this_file_dir/.env ] && export $(cat $this_file_dir/.env | xargs -d '\n')

echo "Checking network..."
if [[ ! $(docker network ls | grep ${PIARA_COMMON_NETWORK_NAME}) ]]; then
    echo "Creating overlay network..."
    docker network create --driver overlay --attachable ${PIARA_COMMON_NETWORK_NAME}
fi

docker stack deploy -c $this_file_dir/${PIARA_COMMON_STACK_NAME}.yml --detach=true --with-registry-auth --prune ${PIARA_COMMON_STACK_NAME}
