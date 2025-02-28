#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Checking network..."
if [[ ! $(docker network ls | grep prometheus-grafana-net) ]]; then
    echo "Creating overlay network..."
    docker network create --driver overlay --attachable prometheus-grafana-net
fi

docker stack deploy -c $this_file_dir/prometheus.yml --detach=true --prune prometheus
