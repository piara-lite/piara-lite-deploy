#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Stopping all services..."
$this_file_dir/down.sh

echo "Starting all services..."
$this_file_dir/up.sh
