#!/bin/bash

## Script to bootstrap Ansible. Meant to be run remotely and served via html. Can be called via curl.
## ex. curl http://angie.home/scripts/ansible.sh | sudo bash

# Add the Ansible repo if necessary
REPO_URL="ppa:ansible/ansible"  # Replace with the repository URL you want to check

if grep ansible /etc/apt/sources.list.d/*; then
    echo "******* Ansible repository exists already and doesn't need to be added. *******"
else
    echo "******* Repository does not exist and needs to be added. *******"
    sudo add-apt-repository --yes --update $REPO_URL
fi

echo '******* updating the software cache *******'
sudo apt update

# Install Ansible if necessary
if dpkg -s ansible &>/dev/null; then
  echo '******* ansible is already installed. nothing to do here *******'
else  
  echo '******* ansible needs to be installed. installing now *******'
  sudo apt install -y ansible
fi

# Ansible first run after installation. It will setup cron so scheduled automatically.
ansible-pull -U https://github.com/ProServicesStorage/ansible_configs.git ansible_ubuntu_desktop.yml
