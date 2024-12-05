# Ansible_Configs

Ansible automation

Automate desktop and server builds for Linux and Mac

A work in progress....

## Server Setup

For server setup I will use a standard push configuration which makes sense with servers. It is agentless which is good and a ssh server is likely already running.

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

To run from the desktop/laptop manually run the following command.

```bash
sudo ansible-pull -U https://github.com/ProServicesStorage/ansible_configs.git ansible_ubuntu_desktop.yml
``` 

### Setup bootstrap server

Prior to running ansible-pull the ansible package needs to be installed on the laptop/desktop we are updating. To do this we can run a shell script from a local web server. You could, of course, just install manually as well using the steps in the script.

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

Initial tests run with a 12-inch MacBook (Early 2016). I initially started working with Homebrew as I have used this in the past but quickly found out this was a no-go. It was taking hours run builds and not only that it isn't even supported on the OS I was testing with, **Monterey**. I used **MacPorts** instead which is supported with Monterey and also worked much faster.

Unfortunately the overall process with a Mac is more manual. Some steps can still be automated!

1. Refresh installation of Mac using Command R during boot. Takes a couple of hours.
2. Update OS. Another 45 minutes with reboot.
3. Change hostname
4. Update DNS to the internal DNS server for local name resolution
5. [optional] Add the new hostname to the local DNS server
6. [optional] Set a static IP via reserved DHCP.
7. Install x-tools. Another 20 minutes.
   
```bash
xcode-select --install
```

8. Download then install MacPorts. You can download from [here](https://www.macports.org/install.php). Click on your version of OSX 
9. Download and install Python for mac. You can get [here](https://www.python.org/downloads/)
10.  Install Python which also installs `pip`. Make sure to click on the **Install Certificates.command" when the installation completes.
11. Upgrade pip

```bash
pip3 install --upgrade pip
```

12. Install Ansible on the Macbook

```bash
pip3 install ansible
```

13. Run playbook from Macbook. Takes about an hour to complete. Curious how long it will take on the Intel Macbook Pro

```bash
sudo ansible-pull -U https://github.com/ProServicesStorage/ansible_configs.git ansible_mac.yml
```

### Additional Mac Steps

1. Fix LazyFonts icons not working. They show with question marks.

It will require Nerd Fonts. Download any one of the fonts. You can get from [here](https://www.nerdfonts.com/font-downloads)

Next open the Font Book in mac and add the Nerd Font. 

The final step is to navigate to the terminal > preferences and select the Nerd Font as the default. Run nvim and the icons will now show correctly.
