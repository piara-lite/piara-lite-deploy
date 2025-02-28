#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
[ -e $this_file_dir/.env ] && export $(cat $this_file_dir/.env | xargs -d '\n')

if [ -e $this_file_dir/.env ]
then
    echo "Removing stack ${PIARA_COMMON_STACK_NAME}"
    docker stack rm ${PIARA_COMMON_STACK_NAME}
    echo ''

    echo 'waiting for services to be removed'
    limit=15
    until [ -z "$(docker service ls --filter name=${PIARA_COMMON_STACK_NAME} -q)" ] || [ "$limit" -lt 0 ]; do
      sleep 2
      limit="$((limit-1))"
    done

    echo 'services:'
    docker service ls
    echo ''
fi
