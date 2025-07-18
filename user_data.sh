#!/bin/bash
set -eux

# Update software
apt update && apt upgrade -y

# Install XFCE
DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies x11-xserver-utils

# Install required dependencies
apt install -y wget curl unzip build-essential awscli
#
# Import NICE DCV GPG key
wget https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
gpg --dearmor < NICE-GPG-KEY | tee /usr/share/keyrings/nice-dcv.gpg > /dev/null
rm NICE-GPG-KEY

# Download and install NICE DCV server
DCV_VERSION="2024.0-19030"  # Update as needed
wget https://d1uj6qtbmh3dt5.cloudfront.net/2024.0/Servers/nice-dcv-${DCV_VERSION}-ubuntu2204-x86_64.tgz
tar -xvzf nice-dcv-${DCV_VERSION}-ubuntu2204-x86_64.tgz
cd nice-dcv-${DCV_VERSION}-ubuntu2204-x86_64
sudo apt install -y ./nice-dcv-server_*.deb ./nice-dcv-web-viewer_*.deb ./nice-xdcv_*.deb

# Add a student user with password
useradd -m -s /bin/bash student
echo 'student:Student123!' | chpasswd

# Set up XFCE as the default session
echo 'exec startxfce4' > /home/student/.xsession
chown student:student /home/student/.xsession

# Enable DCV server
systemctl enable dcvserver
systemctl start dcvserver
#
# Wait until the DCV session broker is ready
until sudo dcv list-sessions &>/dev/null; do
  echo "Waiting for dcvserver to become ready..."
  sleep 2
done

# Create a session
echo "Creating a DCV session for the student"
sudo dcv create-session --owner student --type=virtual student-session
