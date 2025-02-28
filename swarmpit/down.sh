#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

docker stack rm swarmpit
