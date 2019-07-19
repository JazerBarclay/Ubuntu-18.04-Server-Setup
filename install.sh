#!/bin/bash
# Source: https://github.com/JazerBarclay/Ubuntu-18.04-Server-Setup
# Author: Jazer Barclay

display_usage() { 
	echo "This script must be run as root!"
	echo "Usage: sudo $0 [username] [hostname]"
}

if [ \( $# -ne 2 \) -o \( $EUID -ne 0 \) ]
then 
    display_usage
    exit 1
fi

printf "Enter $1's Password:" 
read -s password

apt update && apt -y dist-upgrade && apt -y autoremove && apt -y install vim curl git git-core unattended-upgrades fail2ban ufw
hostnamectl set-hostname $2

groupadd wheel
groupadd dev

cat >>/etc/sudoers <<EOL
#
# Install script
%wheel ALL=(ALL) ALL
Defaults rootpw
EOL

useradd -m -G wheel,dev -s /bin/bash $1
echo $1:$password | chpasswd

ufw allow 22
ufw enable
ufw status

cat >>/etc/apt/apt.conf.d/10periodic <<EOL
APT::Periodic::Unattended-Upgrade "1";
EOL

sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config