#!/bin/bash

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $this_file_dir/deploy-main.config
. $this_file_dir/deploy-main-creds.config

#DATETIME='2024-04-12T00:00:00Z'
#DATETIME=$(date -u -d "" +"%Y-%m-%dT%H:%M:%SZ")
DATETIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
#echo $DATETIME

MISSING_VALUES=false

if [[ -z "${main_creds_server_identity_id}" ]]
then
    MISSING_VALUES=true
    echo Value is empty: main_creds_server_identity_id
fi

if [[ -z "${main_creds_server_identity_name}" ]]
then
    MISSING_VALUES=true
    echo Value is empty: main_creds_server_identity_name
fi

if [[ -z "${main_creds_server_marking_definition_id}" ]]
then
    MISSING_VALUES=true
    echo Value is empty: main_creds_server_marking_definition_id
fi

if [[ -z "${main_creds_server_marking_definition_statement}" ]]
then
    MISSING_VALUES=true
    echo Value is empty: main_creds_server_marking_definition_statement
fi

if [ "${MISSING_VALUES}" = true ]
then
  echo ERROR: Some important values were missing, cannot proceed with this script.
  exit 1
fi

IDENTITY_ID=$main_creds_server_identity_id
IDENTITY_NAME=$main_creds_server_identity_name
MARKING_DEFINITION_ID=$main_creds_server_marking_definition_id
MARKING_DEFINITION_STATEMENT=$main_creds_server_marking_definition_statement
SERVER_URL="https://${main_common_domain_name_server}"
SERVER_USERNAME=$main_creds_server_defaultadmin_username
SERVER_PASSWORD=$main_creds_server_defaultadmin_password

#TOKEN=''
TOKEN=$(curl --insecure -X POST -H 'accept: application/json' -H 'Content-Type: application/json' -d "{ \
    \"username\": \"${SERVER_USERNAME}\", \
    \"password\": \"${SERVER_PASSWORD}\" \
}" "${SERVER_URL}/meridian/api/authenticate" | grep -Po '(?<="id_token": ")[^"]+')
#echo $TOKEN

curl --insecure -i -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header "Authorization: Bearer ${TOKEN}" -d "[{ \
     \"created\": \"${DATETIME}\", \
     \"created_by_ref\": \"${IDENTITY_ID}\", \
     \"id\": \"${IDENTITY_ID}\", \
     \"identity_class\": \"organization\", \
     \"modified\": \"${DATETIME}\", \
     \"name\": \"${IDENTITY_NAME}\", \
     \"object_marking_refs\": [\"${MARKING_DEFINITION_ID}\"], \
     \"type\": \"identity\" \
}, \
{ \
     \"created\": \"${DATETIME}\", \
     \"created_by_ref\": \"${IDENTITY_ID}\", \
     \"id\": \"${MARKING_DEFINITION_ID}\", \
     \"type\": \"marking-definition\", \
     \"definition_type\": \"statement\", \
     \"definition\": { \
         \"statement\": \"${MARKING_DEFINITION_STATEMENT}\" \
     } \
}]" "${SERVER_URL}/meridian/api/stix/custom/bulk"

echo
