#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $this_file_dir/deploy.config

env | grep ^PIARA_COMMON_ | sort > $this_file_dir/.env
env | grep ^PIARA_ADMIN_ | sort > $this_file_dir/.admin.env
env | grep ^PIARA_WEBAPP_ | sort > $this_file_dir/.webapp.env

envsubst < $this_file_dir/${PIARA_COMMON_STACK_NAME}.yml.template > $this_file_dir/${PIARA_COMMON_STACK_NAME}.yml
envsubst < $this_file_dir/traefik/traefik.yml.template > $this_file_dir/traefik/traefik.yml
