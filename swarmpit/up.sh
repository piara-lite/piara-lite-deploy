#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker stack deploy -c $this_file_dir/swarmpit.yml --detach=true --prune swarmpit
