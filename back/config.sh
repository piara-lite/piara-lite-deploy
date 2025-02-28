#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $this_file_dir/deploy.config

env | grep ^PIARA_COMMON_ | sort > $this_file_dir/.env
env | grep ^PIARA_ADMIN_ | sort > $this_file_dir/.admin.env
env | grep ^PIARA_ARANGODBENV_ | sort | awk -F PIARA_ARANGODBENV_ '{ print $2 }' > $this_file_dir/.arangodb.env
env | grep ^PIARA_SERVERCOMMONENV_ | sort | awk -F PIARA_SERVERCOMMONENV_ '{ print $2 }' > $this_file_dir/.server-maintenance.env
env | grep ^PIARA_SERVERMAINTENANCEENV_ | sort | awk -F PIARA_SERVERMAINTENANCEENV_ '{ print $2 }' >> $this_file_dir/.server-maintenance.env
env | grep ^PIARA_SERVERCOMMONENV_ | sort | awk -F PIARA_SERVERCOMMONENV_ '{ print $2 }' > $this_file_dir/.server-core.env
env | grep ^PIARA_SERVERCOREENV_ | sort | awk -F PIARA_SERVERCOREENV_ '{ print $2 }' >> $this_file_dir/.server-core.env
env | grep ^PIARA_DBENV_ | sort | awk -F PIARA_DBENV_ '{ print $2 }' > $this_file_dir/.db.env
env | grep ^PIARA_ESENV_ | sort | awk -F PIARA_ESENV_ '{ print $2 }' > $this_file_dir/.es.env
env | grep ^PIARA_ZOOENV_ | sort | awk -F PIARA_ZOOENV_ '{ print $2 }' > $this_file_dir/.zoo.env
env | grep ^PIARA_KAFKAENV_ | sort | awk -F PIARA_KAFKAENV_ '{ print $2 }' > $this_file_dir/.kafka.env
env | grep ^PIARA_REDISENV_ | sort | awk -F PIARA_REDISENV_ '{ print $2 }' > $this_file_dir/.redis.env

envsubst < $this_file_dir/${PIARA_COMMON_STACK_NAME}.yml.template > $this_file_dir/${PIARA_COMMON_STACK_NAME}.yml
envsubst < $this_file_dir/traefik/traefik.yml.template > $this_file_dir/traefik/traefik.yml
