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


## Desktop Setup

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
