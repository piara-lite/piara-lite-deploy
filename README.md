# PIARA Lite Deploy 18.x

### Prerequisites <a href="#prerequisites" id="prerequisites"></a>

* Debian latest LTS in VirtualBox (4 CPU / 8 MEM / 40 GB DISK)
  * How to create VirtualBox on your local computer see separate section in this document
  * Optionally you can deploy PIARA Lite in Cloud VM, see separate section for "Advanced deploy" in this document
* Docker already installed, e.g. using this manual: [https://docs.docker.com/engine/install/debian/](https://docs.docker.com/engine/install/debian/)
  *   Swarm mode initialized, e.g. using this manual: [https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/)\
      For simple cases just execute the command:

      ```
      docker swarm init --advertise-addr 127.0.0.1
      ```
* PIARA Lite license key (should be sent to your email during Stripe free subscription registration)

### Assumptions and limitations <a href="#assumptions-and-limitations" id="assumptions-and-limitations"></a>

* Both `front` and `back` stacks should run on the same machine (Docker Swarm node).
* All commands are executed being in `piara` folder in your VM, unless otherwise stated.

### Steps <a href="#steps" id="steps"></a>

1. Pull depoly scripts and configs by executing command being in `/root` folder on your VM
   ```
   git clone https://github.com/piara-lite/piara-lite-deploy.git piara
   ```
   1. Alternatively you may upload deploy scripts zip archive and unpack into `/root` folder on your VM and then rename unpacked folder into `piara`
2.  Being in `piara` folder execute commands:

    1. ```
       chmod ug+x piara.sh
       ```
    2. ```
       ./piara.sh install
       ```
3. Follow the installation wizard by entering:
   - Your license key
   - Webapp domain name (press Enter to keep default)
   - Server domain name (press Enter to keep default)
   - Identity Name (any suitable text)
   - Marking Definition Statement (any suitable text)
4. At the end of deployment you will see the output with generated login and password for default admin account. Also there will be URLs for entering PIARA Webapp and PIARA Admin Panel.
8.  After deployment finished, run the following command to ensure that all services were started:

    ```
    docker stack services piara-back
    ```
    and
    ```
    docker stack services piara-front
    ```

    (i.e., the column "REPLICAS" must have all 1/1 values)
10. Inject generated unique `identity` and `marking-definition` objects for this env into Server, by running command:

    ```
    back/add-identity.sh
    ```
11. Navigate in browser to PIARA Admin Panel on route `/admin` in browser and login with default creds for Server.
    1. [https://piaralite.piaratestsandbox.net/admin](https://piaralite.piaratestsandbox.net/admin)
12. In PIARA Admin add new admin user (with different credentials)
    1. Give this user roles: `Admin` and `ROLE_ADMIN`
    2. Login with this new user credentials and **disable default admin** user
13. Add more users in PIARA Admin (if needed). Grant Metadata API access permission for each user in the system (and for new users when adding them) `Meridian Web API -> Get Server Metadata` otherwise they will not be able even to login into Webapp
14. Open domain name root URL in browser and login into Webapp
    1. [https://piaralite.piaratestsandbox.net](https://piaralite.piaratestsandbox.net)

### Installation in VirtualBox <a href="#installation-in-virtualbox" id="installation-in-virtualbox"></a>

1. Your computer must have enough resources to allocate the following to a guest Virtual Machine:
   1. 4 CPU, 8 RAM, 40GB disk space.
   2. Note. Keep in mind, you still need resources for the host. Ideally, host should have at least double of that in 1.a.
2. Download and install latest VirtualBox for Windows:\
   [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
3. Download latest stable (LTS) Debian image (amd64):\
   [https://www.debian.org/CD/http-ftp/#stable](https://www.debian.org/CD/http-ftp/#stable)
4. Create new VM in VirtualBox:
   1. Chose a “Name” for the new virtual machine
   2. Keep “Folder” unchanged(unless you want a different location)
   3. Find the Debian ISO image that you just downloaded in step #2.
   4. Do **NOT** “Skip Unattended Install”
   5. Pick “Username” and “Password”. (default username is “vboxuser”, password is “changeme”)
   6.  Set “Hostname” to:

       ```
       piaralite
       ```
   7.  Set “Domain Name” to:

       ```
       piaratestsandbox.net
       ```
   8. Minimum system requirements:
      1. Processors: 4 CPU
      2. Base Memory: 8 GB RAM (same as 8192 MB)
      3. Virtual Hard disk: 40 GB
5. After Debian is installed, login to the guest Debian VM with the credentials from the step 4.e
6. Open command line terminal:
7.  Switch to `root` . Password for the `root` is the same as in step 4.e.

    ```
    su -
    ```
8. Setup SSH server(you must be root after the step 7):
   1.  install openssh-server

       ```
       apt install openssh-server
       ```
   2.  Check status to make sure that the server is “active”

       ```
       systemctl status ssh
       ```
   3.  Allow root to connect by adjusting sshd config: 1.

       ```
       nano /etc/ssh/sshd_config
       ```

       2. Find `#PermitRootLogin prohibit-password`
          1. Uncomment this line(i.e., remove `#` )
          2.  Change the line to

              ```
              PermitRootLogin yes
              ```
          3. Save the changes:
             1. In nano editor, press `Ctrl + X`
             2. Next press “y”
             3. Next press “Enter”.
9. Disable GUI (you must be root after the step 7):
   1.  Execute to disable GUI:

       ```
       systemctl set-default multi-user.target
       ```

       Optional. If you will need to enable GUI later, you can do this with a command:

       ```
       systemctl set-default graphical.target
       ```
   2.  Shutdown the guest Debian VM:

       ```
       shutdown now
       ```
10. In VirtualBox, enable port forwarding for the Debian VM so you can access it via SSH from your host machine, plus PIARA.
    1. First, choose the Debian VM, then open _“Settings” >> “Network” >> “Advanced”_ section. This will show additional network adapter options. Then, we click on “_Port Forwarding_” button.
    2.  Click on the plus '+' icon and add the following:

        | Name  | Protocol | Host IP | Host Port | Guest IP | Guest Port |
        | ----- | -------- | ------- | --------- | -------- | ---------- |
        | PIARA | TCP      |         | 443       |          | 443        |
        | SSH   | TCP      |         | 2224      |          | 22         |
11. Start the guest Debian VM.
12. To connect to the guest Debian via SSH use:
    1. Username: root
    2. Password: the user’s password you picked in step 3.e
    3. IP: localhost
    4. Port: 2224
    5.  Example command for the terminal on your host machine:

        ```
        ssh root@localhost -p 2224
        ```
13. After that you may follow normal setup steps, and then access PIARA Lite in your host machine browser:
    1. [https://piaralite.piaratestsandbox.net](https://piaralite.piaratestsandbox.net)
