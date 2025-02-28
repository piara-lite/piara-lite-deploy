#!/bin/bash

# This script initializes a project environment or performs specified actions based on CLI commands.

# Define list of commands with descriptions
declare -A COMMANDS=(
    [1]="install:Install the application"
    [2]="start:Start the services"
    [3]="restart:Restart the services"
    [4]="stop:Stop the services"
    [5]="rebuild:Rebuild the application (rebuild configs and restart)"
)

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if Docker Swarm mode is initialized
if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q 'active'; then
    echo "Docker Swarm mode is not initialized. Please initialize it and try again."
    exit 1
fi

# Define color variables
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Define the logo as a variable
LOGO="
██████╗ ██╗ █████╗ ██████╗  █████╗ 
██╔══██╗██║██╔══██╗██╔══██╗██╔══██╗  _    _ _       
██████╔╝██║███████║██████╔╝███████║ | |  (_) |_ ___ 
██╔═══╝ ██║██╔══██║██╔══██╗██╔══██║ | |__| |  _/ -_)
██║     ██║██║  ██║██║  ██║██║  ██║ |____|_|\__\___|
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
"

# Function to display the logo
show_logo() {
    # Output the ASCII art
    echo -e "${GREEN}${LOGO}${RESET}"
}

# Function to handle the install command
install_environment() {
    # Read stack names from deploy.config
    BACK_STACK_NAME=$(grep "^export PIARA_COMMON_STACK_NAME=" back/deploy.config | cut -d'=' -f2 | tr -d "'")
    FRONT_STACK_NAME=$(grep "^export PIARA_COMMON_STACK_NAME=" front/deploy.config | cut -d'=' -f2 | tr -d "'")

    # Check if any services are running in the back stack
    if [ "$(docker stack services "$BACK_STACK_NAME" --format '{{.Name}}' | wc -l)" -gt 0 ]; then
        docker stack services "$BACK_STACK_NAME"
        echo -e "${RED}Services are already running in the back stack '$BACK_STACK_NAME'. Do you want to stop them? (y/n)${RESET}"
        read -r user_response

        if [[ "$user_response" == "y" || "$user_response" == "Y" ]]; then
            echo "Stopping services..."
            # Execute the command to stop the services
            ./back/down.sh

            # Wait for the services to stop completely
            while [ "$(docker stack services "$BACK_STACK_NAME" --format '{{.Name}}' | wc -l)" -gt 0 ]; do
                echo -n "Waiting for services to stop... "
                sleep 5  # Wait for 5 seconds before checking again
            done

            echo -e "${GREEN}Services have been stopped successfully. Proceeding...${RESET}"            
        else
            echo "Please stop the services manually before proceeding. E.g. with a command back/down.sh"
            exit 1
        fi
    fi

    # Check if any services are running in the front stack
    if [ "$(docker stack services "$FRONT_STACK_NAME" --format '{{.Name}}' | wc -l)" -gt 0 ]; then
        docker stack services "$FRONT_STACK_NAME"
        echo -e "${RED}Services are already running in the front stack '$FRONT_STACK_NAME'. Do you want to stop them? (y/n)${RESET}"
        read -r user_response

        if [[ "$user_response" == "y" || "$user_response" == "Y" ]]; then
            echo "Stopping services..."
            # Execute the command to stop the services
            ./front/down.sh

            # Wait for the services to stop completely
            while [ "$(docker stack services "$FRONT_STACK_NAME" --format '{{.Name}}' | wc -l)" -gt 0 ]; do
                echo -n "Waiting for services to stop... "
                sleep 5  # Wait for 5 seconds before checking again
            done

            echo -e "${GREEN}Services have been stopped successfully. Proceeding...${RESET}"            
        else
            echo "Please stop the services manually before proceeding. E.g. with a command front/down.sh"
            exit 1
        fi
    fi

    # Execute permissions and setup
    chmod ug+x perms.sh
    ./perms.sh
    echo "y" | ./perms-data.sh

    # Call the show_logo function to display the logo
    show_logo

    # Prompt for license key
    read -p "Enter your license key (Press Enter to leave intact): " LICENSE_KEY
    if [[ -n "$LICENSE_KEY" ]]; then
        sed -i "s/^main_creds_server_main_licensing_key='[^']*'/main_creds_server_main_licensing_key='$LICENSE_KEY'/" back/deploy-main-creds.config
    fi

    # Prompt for domains with defaults
    DEFAULT_WEBAPP_DOMAIN="piaralite.piaratestsandbox.net"
    DEFAULT_SERVER_DOMAIN="piaralite-ws.piaratestsandbox.net"

    read -p "Enter Webapp Domain (Press Enter to leave intact, original config typically contains: $DEFAULT_WEBAPP_DOMAIN): " WEBAPP_DOMAIN
    if [[ -n "$WEBAPP_DOMAIN" ]]; then
        sed -i "s/^main_common_domain_name_webapp='[^']*'/main_common_domain_name_webapp='$WEBAPP_DOMAIN'/" back/deploy-main.config
        sed -i "s/^main_common_domain_name_webapp='[^']*'/main_common_domain_name_webapp='$WEBAPP_DOMAIN'/" front/deploy-main.config
    fi

    read -p "Enter Server Domain (Press Enter to leave intact, original config typically contains: $DEFAULT_SERVER_DOMAIN): " SERVER_DOMAIN
    if [[ -n "$SERVER_DOMAIN" ]]; then
        sed -i "s/^main_common_domain_name_server='[^']*'/main_common_domain_name_server='$SERVER_DOMAIN'/" back/deploy-main.config
        sed -i "s/^main_common_domain_name_server='[^']*'/main_common_domain_name_server='$SERVER_DOMAIN'/" front/deploy-main.config
    fi

    # Prompt for identity and marking definitions
    read -p "Enter Identity Name (Press Enter to leave intact): " IDENTITY_NAME
    if [[ -n "$IDENTITY_NAME" ]]; then
        sed -i "s/^main_creds_server_identity_name='[^']*'/main_creds_server_identity_name='$IDENTITY_NAME'/" back/deploy-main-creds.config
    fi

    read -p "Enter Marking Definition Statement (Press Enter to leave intact): " MARKING_STATEMENT
    if [[ -n "$MARKING_STATEMENT" ]]; then
        sed -i "s/^main_creds_server_marking_definition_statement='[^']*'/main_creds_server_marking_definition_statement='$MARKING_STATEMENT'/" back/deploy-main-creds.config
    fi

    # Generate self-signed SSL certificate
    cd front/secrets

    openssl genrsa -aes256 -passout pass:gsahdg -out certkey.pem.pass 4096
    openssl rsa -passin pass:gsahdg -in certkey.pem.pass -out certkey.pem
    rm certkey.pem.pass
    # commonName - required for Chrome, subjectAltName - for Python (otherwise it will warn), subjectAltName can be multiple (comma-separated)
    openssl req -new -key certkey.pem -out certbundle.csr -addext "subjectAltName=DNS:*.piaratestsandbox.net" -subj "/CN=*.piaratestsandbox.net"
    openssl x509 -req -sha256 -days 365 -copy_extensions=copyall -in certbundle.csr -signkey certkey.pem -out certbundle.pem
    rm certbundle.csr

    cp certbundle.pem ../../back/secrets/
    cp certkey.pem ../../back/secrets/

    cd ../..

    # Generate passwords
    back/generate-passwords.sh

    # Deploy front and back
    front/deploy.sh
    back/deploy.sh

    # Output details
    ADMIN_USERNAME=$(grep "^main_creds_server_defaultadmin_username=" back/deploy-main-creds.config | cut -d'=' -f2 | sed 's/\s*#.*//g' | tr -d "'")
    ADMIN_PASSWORD=$(grep "^main_creds_server_defaultadmin_password=" back/deploy-main-creds.config | cut -d'=' -f2 | sed 's/\s*#.*//g' | tr -d "'")
    WEBAPP_DOMAIN=$(grep "^main_common_domain_name_webapp=" front/deploy-main.config | cut -d'=' -f2 | sed 's/\s*#.*//g' | tr -d "'")

    echo -e "${GREEN}╔══════════════════════╗${RESET}"
    echo -e "${GREEN}║ Deployment Complete: ║${RESET}"
    echo -e "${GREEN}╚══════════════════════╝${RESET}"

    cat <<EOF
- Webapp URL: https://$WEBAPP_DOMAIN
- Admin Panel URL: https://$WEBAPP_DOMAIN/admin
- Admin Username: $ADMIN_USERNAME
- Admin Password: $ADMIN_PASSWORD
EOF
}

# Function to display menu if no CLI argument is provided
show_menu_and_execute() {
    # Call the show_logo function to display the logo
    show_logo

    echo "Select an option:" 
    for key in $(echo "${!COMMANDS[@]}" | tr ' ' '\n' | sort -n); do 
        # Split command and description
        IFS=":" read -r command description <<< "${COMMANDS[$key]}"
        # Output command with description using tab
        echo -e "${GREEN}($key)${RESET} ${command}\t${description}"
    done 
    read -p "Enter the number of your choice: " choice

    # Split command and description
    IFS=":" read -r command description <<< "${COMMANDS[$choice]}"

    if [ -n "$command" ]; then
        execute_command "$command"
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi
}

# Function to execute commands
execute_command() {
    case "$1" in
        install)
            install_environment
            ;;
        start)
            front/up.sh
            back/up.sh
            ;;
        restart)
            front/restart.sh
            back/restart.sh
            ;;
        stop)
            front/down.sh
            back/down.sh
            ;;
        rebuild)
            front/deploy.sh
            back/deploy.sh
            ;;
        *)
            echo "Unknown command: $1"
            exit 1
            ;;
    esac
}

# CLI Command Handling
if [ -z "$1" ]; then
    show_menu_and_execute
else
    execute_command "$1"
fi
