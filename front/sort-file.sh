#!/bin/bash

# Keeping .env files sorted helps compare configurations on different environments.
# Or compare configurations of one environment over the time.

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

env LC_COLLATE='en_US.UTF-8' sort $1 > $1.sorted
