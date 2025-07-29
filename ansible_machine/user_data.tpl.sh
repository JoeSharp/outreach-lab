#!/bin/bash
set -eux

# Update software
apt-add-repository --yes --update ppa:ansible/ansible
apt update && apt upgrade -y

# Install XFCE
DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies x11-xserver-utils

# Install required dependencies
apt install -y \
	wget \
	curl \
	unzip \
	build-essential \
	awscli \
	software-properties-common \
	ansible \
	git \
	python3-passlib \
	unzip 

# Import NICE DCV GPG key
wget https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
gpg --dearmor < NICE-GPG-KEY | tee /usr/share/keyrings/nice-dcv.gpg > /dev/null
rm NICE-GPG-KEY

# Download and install NICE DCV server
DCV_VERSION="2024.0-19030"  # Update as needed
wget https://d1uj6qtbmh3dt5.cloudfront.net/2024.0/Servers/nice-dcv-$${DCV_VERSION}-ubuntu2204-x86_64.tgz
tar -xvzf nice-dcv-$${DCV_VERSION}-ubuntu2204-x86_64.tgz
cd nice-dcv-$${DCV_VERSION}-ubuntu2204-x86_64
apt install -y ./nice-dcv-server_*.deb ./nice-dcv-web-viewer_*.deb ./nice-xdcv_*.deb

# Add a student user with password
useradd -m -s /bin/bash ${username}
echo '${username}:${password}' | chpasswd

# Set up XFCE as the default session
echo 'exec startxfce4' > /home/${username}/.xsession
chown ${username}:${username} /home/${username}/.xsession

# Enable DCV server
systemctl enable dcvserver
systemctl start dcvserver

# Wait until the DCV session broker is ready
until dcv list-sessions &>/dev/null; do
  echo "Waiting for dcvserver to become ready..."
  sleep 2
done

# Create a session
echo "Creating a DCV session for ${username}"
dcv create-session --owner ${username} --type=virtual student-session

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Fetch the Ansible playbook
aws s3 cp s3://${ansible_playbook} /opt/ansible/playbook.yml

# Run playbook
ansible-playbook /opt/ansible/playbook.yml

