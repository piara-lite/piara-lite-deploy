#!/bin/bash

cd ${PWD} #workaround for docker-compose crash on Windows WSL2

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo
echo ---
echo Set permissions for $this_file_dir
echo ---
echo

# Ownership and permissions for already existing folders are set recursively by the script in parent folder.
# Each new folder in the hierarchy created separately to make sure all of them will have proper permissions set.

ls -la $this_file_dir

chmod ugo+r $this_file_dir/es/configs/elasticsearch.yml
chmod ugo+r $this_file_dir/es/configs/log4j2.properties
chmod ugo+rw $this_file_dir/server/essettings
chmod ugo+r $this_file_dir/build.json

mkdir -p -m ugo+rwx $this_file_dir/secrets

declare -a arr_secrets=( \
    "certbundle.pem" \
    "certkey.pem" \
)

for file in "${arr_secrets[@]}"
do
    if [[ ! -f "${this_file_dir}/secrets/${file}" ]]
    then
        echo -n " " > "${this_file_dir}/secrets/${file}"
    fi
done

ls -la $this_file_dir
