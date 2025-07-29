#!/bin/bash

# Update and install Ansible dependencies
apt update && apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible git python3-passlib unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

aws s3 cp s3://${ansible_playbook.key} /opt/ansible/playbook.yml

echo "[localhost]" > /opt/ansible/hosts

# Run playbook
ansible-playbook -i /opt/ansible/hosts /opt/ansible/playbook.yml

