# PIARA Lite Deploy 18.x

### Prerequisites <a href="#prerequisites" id="prerequisites"></a>
* Debian 64-bit (amd64) latest (LTS) release.
  * Hardware Requirements:
    * CPU: 4 cores
    * Memory: 8 GB RAM 
    * Disk Space: 40 GB
* PIARA Lite License Key: Obtain a free license key from our website: [piarainc.com](https://piarainc.com)

### Steps <a href="#steps" id="steps"></a>

1. Connect to your Debian server via SSH
   * Open your terminal and replace `<SERVER_IP_ADDRESS>` with the actual IP address of your Debian server.
   ```shell
   ssh root@<SERVER_IP_ADDRESS>
   ```
   
1. Set up Docker's `apt` repository
    ```shell
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    ```
1. Install the latest version of Docker
    ```shell
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

1. Initialize a Docker Swarm
    ```shell
    docker swarm init --advertise-addr 127.0.0.1
    ```
1. Install `git`
    ```shell
    apt install git
    ```
1. Download deployment scripts and configs
    ```shell
    git clone https://github.com/piara-lite/piara-lite-deploy.git piara
    ```

1. Run the PIARA installation script

    The `piara.sh` script automates the installation process.
    ```shell
    cd piara/
    chmod ug+x piara.sh
    ./piara.sh install
    ```

1. Follow the installation wizard
    * You will be prompted to enter the following information:
        - Your license key
        - Webapp domain name (Press Enter to keep default: piaralite.piaratestsandbox.net)
        - Identity Name (Enter any suitable text)
        - Marking Definition Statement (Enter any suitable text)

1. Copy the output information
   * The installation script will output the following information:
       - Webapp URL
       - Admin Username
       - Admin Password
     
     **Important:** Store this information in a secure location

1. After the installation scripts complete, verify the service status by running the following commands 
    
    If the "REPLICAS" column shows "1/1" for each service, all services have successfully started.
    ```shell
    docker stack services piara-back
    ```
    and
    ```shell
    docker stack services piara-front
    ```

    **Note:** It may take up to 10 minutes for all services to start

1. Create `identity` and `marking-definition` objects

    This script configures the identity and marking definitions for your environment
    ```shell
    back/add-identity.sh
    ```
    

1. Open your web browser to log in. Log in using the admin username and password displayed during the installation wizard
   
   * **Scenario 1: Local Virtual Machine with Default Domain**
     * If you installed PIARA Lite on a virtual machine on your local computer and used the default Webapp domain name during installation, open [https://piaralite.piaratestsandbox.net](https://piaralite.piaratestsandbox.net) in your web browser

   * **Scenario 2: Local Virtual Machine with Custom Domain**
     * If you installed PIARA Lite on a virtual machine on your local computer and entered a custom Webapp domain name, you need to add an entry to your local computer's `/etc/hosts` file.
     * Add the following line to your `/etc/hosts` file, replacing `<SERVER_IP_ADDRESS>` with the IP address of your virtual machine:
     ```shell
     <SERVER_IP_ADDRESS> yourcustomdomain.com
     ```
     * Then, open your custom domain (e.g., `http://yourcustomdomain.com`) in your web browser.

   * **Scenario 3: Cloud Virtual Machine with Default Domain**
     * If you installed PIARA Lite on a virtual machine in the cloud and used the default Webapp domain name during installation, you need to add an entry to your local computer's `/etc/hosts` file

     * Add the following line to your `/etc/hosts` file, replacing `<SERVER_IP_ADDRESS>` with the public IP address of your cloud virtual machine:
     ```shell
     <SERVER_IP_ADDRESS> piaralite.piaratestsandbox.net
     ```
     * Then, open [https://piaralite.piaratestsandbox.net](https://piaralite.piaratestsandbox.net) in your web browser.

     * **Important:** You may need to configure your cloud provider's firewall to allow access to the server

   * **Scenario 4: Cloud Virtual Machine with Custom Domain**
     * If you installed PIARA Lite on a virtual machine in the cloud and entered a custom Webapp domain name, you need to add an entry to your local computer's `/etc/hosts` file.

     * Add the following line to your `/etc/hosts` file, replacing `<SERVER_IP_ADDRESS>` with the public IP address of your cloud virtual machine:
     ```shell
     <SERVER_IP_ADDRESS> yourcustomdomain.com
     ```
            
     * Then, open your custom domain (e.g., `http://yourcustomdomain.com`) in your web browser.
     * **Important:** You may need to configure your cloud provider's firewall to allow access to the server.

### Installation in VirtualBox <a href="#installation-in-virtualbox" id="installation-in-virtualbox"></a>

1. Your computer must have enough resources to allocate the following to a guest Virtual Machine:
   1. 4 CPU, 8 RAM, 40GB disk space.
   1. Note. Keep in mind, you still need resources for the host. Ideally, host should have at least double of that in 1.a.
1. Download and install latest VirtualBox for Windows:\
   [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
1. Download latest stable (LTS) Debian image (amd64):\
   [https://www.debian.org/CD/http-ftp/#stable](https://www.debian.org/CD/http-ftp/#stable)
1. Create new VM in VirtualBox:
   1. Chose a “Name” for the new virtual machine
   1. Keep “Folder” unchanged(unless you want a different location)
   1. Find the Debian ISO image that you just downloaded in step #2.
   1. Do **NOT** “Skip Unattended Install”
   1. Pick “Username” and “Password”. (default username is “vboxuser”, password is “changeme”)
   1.  Set “Hostname” to:

       ```
       piaralite
       ```
   1.  Set “Domain Name” to:

       ```
       piaratestsandbox.net
       ```
   1. Minimum system requirements:
      1. Processors: 4 CPU
      1. Base Memory: 8 GB RAM (same as 8192 MB)
      1. Virtual Hard disk: 40 GB
1. After Debian is installed, login to the guest Debian VM with the credentials from the step 4.e
1. Open command line terminal:
1.  Switch to `root` . Password for the `root` is the same as in step 4.e.

    ```
    su -
    ```
1. Setup SSH server(you must be root after the step 7):
   1.  install openssh-server

       ```
       apt install openssh-server
       ```
   1.  Check status to make sure that the server is “active”

       ```
       systemctl status ssh
       ```
   1.  Allow root to connect by adjusting sshd config:

       ```
       nano /etc/ssh/sshd_config
       ```

       1. Find `#PermitRootLogin prohibit-password`
          1. Uncomment this line(i.e., remove `#` )
          1.  Change the line to

              ```
              PermitRootLogin yes
              ```
          1. Save the changes:
             1. In nano editor, press `Ctrl + X`
             1. Next press “y”
             1. Next press “Enter”.
1. Disable GUI (you must be root after the step 7):
   1.  Execute to disable GUI:

       ```
       systemctl set-default multi-user.target
       ```

       Optional. If you will need to enable GUI later, you can do this with a command:

       ```
       systemctl set-default graphical.target
       ```
   1.  Shutdown the guest Debian VM:

       ```
       shutdown now
       ```
1. In VirtualBox, enable port forwarding for the Debian VM so you can access it via SSH from your host machine, plus PIARA.
    1. First, choose the Debian VM, then open _“Settings” >> “Network” >> “Advanced”_ section. This will show additional network adapter options. Then, we click on “_Port Forwarding_” button.
    1.  Click on the plus '+' icon and add the following:

        | Name  | Protocol | Host IP | Host Port | Guest IP | Guest Port |
        | ----- | -------- | ------- | --------- | -------- | ---------- |
        | PIARA | TCP      |         | 443       |          | 443        |
        | SSH   | TCP      |         | 2224      |          | 22         |
1. Start the guest Debian VM.
1. To connect to the guest Debian via SSH use:
    1. Username: root
    1. Password: the user’s password you picked in step 3.e
    1. IP: localhost
    1. Port: 2224
    1.  Example command for the terminal on your host machine:

        ```
        ssh root@localhost -p 2224
        ```
1. After that you may follow normal setup steps, and then access PIARA Lite in your host machine browser:
    1. [https://piaralite.piaratestsandbox.net](https://piaralite.piaratestsandbox.net)
