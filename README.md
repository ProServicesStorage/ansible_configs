# Ansible_Configs

Ansible automation

Automate desktop and server builds for Linux and Mac

A work in progress....

## Setup bootstrap server

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
