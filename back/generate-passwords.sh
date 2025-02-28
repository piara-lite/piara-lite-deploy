#!/bin/bash

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $this_file_dir/deploy-main-creds.config

FILE=$this_file_dir/deploy-main-creds.config

# # # # #
#
#  Function definitions
#
# # # # #

# Creating a password in Bash
# https://stackoverflow.com/questions/44376846/creating-a-password-in-bash

# Generate a url safe password.
password() {
    #local length=${1:-"32"}
    local length=${1:-"$(shuf -i 32-64 -n 1 --random-source=/dev/urandom)"}
    #local length=$(shuf -i 32-64 -n 1)
    #local length=$(shuf -i 32-64 -n 1 --random-source=/dev/urandom)
    #local length=32
    cat /dev/urandom | tr -dc A-Za-z0-9 | head -c $length && echo
}

# Generate a url safe password that:
# - begins with a letter, and has at least
# - one uppercase letter,
# - one lowercase letter,
# - one digit
checked_password() {
    while :
    do
        local pass=$(password "$1")
        [[ $pass != [A-Za-z]* ]] && continue
        [[ $pass != *[A-Z]* ]] && continue
        [[ $pass != *[a-z]* ]] && continue
        [[ $pass != *[0-9]* ]] && continue
        echo "$pass"
        break
    done
}

# Username suffix
username_suffix() {
    cat /dev/urandom | tr -dc 1-9 | head -c 5 && echo
}

# # # # #
#
#  Piara username and password
#
# # # # #

#main_creds_server_defaultadmin_password=''
#main_creds_server_defaultadmin_username=''

declare -a arr_piara_usernames=( \
    "main_creds_server_defaultadmin_username" \
)

declare -a arr_piara_passwords=( \
    "main_creds_server_defaultadmin_password" \
)

piara_username="admin$(username_suffix)"
#echo "${piara_username}"
# PIARA does not allow passwords longer than 32
piara_password=$(checked_password 32)
#echo "${piara_password}"

for i in "${arr_piara_usernames[@]}"
do
    if [[ -z "${!i}" ]]
    then
        EXPR=("s|$i=''|$i='${piara_username}'|g")
        sed -i "${EXPR[@]}" ${FILE}
    fi
done

for i in "${arr_piara_passwords[@]}"
do
    if [[ -z "${!i}" ]]
    then
        EXPR=("s|$i=''|$i='${piara_password}'|g")
        sed -i "${EXPR[@]}" ${FILE}
    fi
done

# # # # #
#
#  DB username
#
# # # # #

#main_creds_server_db_username=''

if [[ -z "${main_creds_server_db_username}" ]]
then
    username="dbuser$(username_suffix)"
    #echo "${username}"
    EXPR=("s|main_creds_server_db_username=''|main_creds_server_db_username='${username}'|g")
    sed -i "${EXPR[@]}" ${FILE}
fi

# # # # #
#
#  Foreigns encryption key
#
# # # # #

#main_creds_server_db_encryptionkey=''

if [[ -z "${main_creds_server_db_encryptionkey}" ]]
then
    #For AES, the legal key sizes are 128, 192, and 256 bits.
    password=$(checked_password 32)
    #echo "${password}"
    EXPR=("s|main_creds_server_db_encryptionkey=''|main_creds_server_db_encryptionkey='${password}'|g")
    sed -i "${EXPR[@]}" ${FILE}
fi

# # # # #
#
#  All other passwords
#
# # # # #

declare -a arr_passwords=( \
    "main_creds_arangodb_root_password" \
    "main_creds_redis_password" \
    "main_creds_server_db_password" \
    "main_creds_server_es_basic_password" \
    "main_creds_server_token_secret" \
)

for i in "${arr_passwords[@]}"
do
    # You can access them using echo "${arr[0]}", "${arr[1]}" also
    if [[ -z "${!i}" ]]
    then
        password=$(checked_password)
        #echo "${password}"
        EXPR=("s|$i=''|$i='${password}'|g")
        sed -i "${EXPR[@]}" ${FILE}
    fi
done

# # # # #
#
#  Identity and marking-definition IDs
#
# # # # #

#main_creds_server_identity_id=''
#main_creds_server_marking_definition_id=''

if [[ -z "${main_creds_server_identity_id}" ]]
then
    #uuid=$(uuidgen)
    uuid=$(cat /proc/sys/kernel/random/uuid)
    #echo "${uuid}"
    EXPR=("s|main_creds_server_identity_id=''|main_creds_server_identity_id='identity--${uuid}'|g")
    sed -i "${EXPR[@]}" ${FILE}
fi

if [[ -z "${main_creds_server_marking_definition_id}" ]]
then
    #uuid=$(uuidgen)
    uuid=$(cat /proc/sys/kernel/random/uuid)
    #echo "${uuid}"
    EXPR=("s|main_creds_server_marking_definition_id=''|main_creds_server_marking_definition_id='marking-definition--${uuid}'|g")
    sed -i "${EXPR[@]}" ${FILE}
fi
