#!/bin/bash

df -h -x overlay -x tmpfs

docker system df
docker system prune -f
docker volume prune -f
docker image prune -af
docker system df

df -h -x overlay -x tmpfs
