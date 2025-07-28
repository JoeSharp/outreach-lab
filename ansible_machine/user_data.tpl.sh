#!/bin/bash

# Update and install Ansible dependencies
apt update && apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible git

mkdir -p /opt/ansible
cp /ansible/playbook.yml /opt/ansible/
echo "[localhost]" > /opt/ansible/hosts

# Run playbook
ansible-playbook -i /opt/ansible/hosts /opt/ansible/playbook.yml

