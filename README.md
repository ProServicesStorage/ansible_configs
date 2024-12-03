# Ansible_Configs

Ansible automation

Automate desktop and server builds for Linux and Mac

A work in progress....

## Server Setup

For server setup I will use a standard push configuation which makes sense with servers. It is agentless which is good and a ssh server is likely already running.

### Prepare ssh

It is necessary for ssh server to be running on any clients the Ansible server will connect to. In addition, I will use a ssh key without a passphrase to easily connect to each client automatically. This key will be used by a dedicated user for ansible.

1. If necessary generate a new ssh key on the Ansible server.

```bash
# The -C option is optional but is a descriptive comment and useful.
ssh-keygen -t ed25519 -C "ansible"
```

2. Copy the key to the destination clients.

```bash
ssh-copy-id -i ~/.ssh/ansible.pub client1
```

3. SSH to the client from the Ansible server at least once. This is to accept the one-time fingerprint prompt.

```bash
ssh -i ~/.ssh/ansible client1
```


## Linux Desktop Setup

I use ansible-pull for my linux and mac desktop / laptops. This seems to make more sense than a push configuration due to the very nature of workstations that can be powered off randomly and potentially located anywhere. Pull rather than push lends itself to this.

### Setup bootstrap server

Prior to running ansible-pull the ansilbe package needs to be installed. To do this we can run a shell script from a local web server.

Complete the following steps on a web server.

1. Install Apache

```bash
sudo apt update
sudo apt install apache2
```

2. Create the script

```bash
cd /var/www/html
sudo mkdir scripts
sudo touch ansible.sh
```
Make she script executable

```bash
sudo chmod +x /var/www/html/scripts/ansible.sh
```

3. Configure Apache

Enable CGI support in Apache.

```bash
sudo a2enmod cgi
```

Create a .htaccess file in the directory containing your script (/var/www/html/scripts/) to allow CGI execution:

```bash
sudo nano /var/www/html/scripts/.htaccess
```

Add the following content to the .htaccess file

```bash
Options +ExecCGI
AddHandler cgi-script .sh
```

4. Run the script from a new desktop

```bash
curl http://angie.home/scripts/ansible.sh | sudo bash
```

## Mac Setup

I have a couple of older Macbooks and I wanted to test automating there build. The idea being to reinstall the OS periodically and then run an ansible script to automate the build. There is some info out there but it is more limited compared to Linux. 

I initially started working with Homebrew as I have used this in the past but quickly find out this was a no-go. It was taking hours run builds and not only that it isn't even supported on the OS I was testing with, Monterey. I used Macports instead which is supported with Monterey and also worked much faster.

Unfortunately the overrall process with a Mac is more manual.

1. Refresh installation of Mac using Command R during boot

2. Update OS

3. Install x-tools

4. Download and install Python for mac. You can get [here](https://www.python.org/downloads/)

5. Install Python which also installs `pip`

6. Upgrade pip

```bash
pip3 install --upgrade pip
```

7. Install Ansible on the macbook

```bash
pip3 install ansible
```

8. Run playbook from macbook.

```bash
sudo ansible-pull -U https://github.com/ProServicesStorage/ansible_configs.git ansible_mac.yml
```
