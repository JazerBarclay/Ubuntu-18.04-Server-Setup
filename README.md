# Ubuntu-18.04-Server-Setup
A basic setup and installation guide for ubuntu server 18.04 on linode<br>
Video: [My First 7 Minutes On An Ubuntu Server - Essential Security for Linux Servers](https://www.youtube.com/watch?v=KjuSf_aPYFg)

## Update, Upgrade and Remove old
`apt update && apt -y dist-upgrade && apt -y autoremove`
## Install vim, curl, git, git-core, unattended-upgrades, fail2ban and ufw
`apt -y install vim curl git git-core unattended-upgrades fail2ban ufw`
## Set the hostname
`hostnamectl set-hostname example.com`
## Test change using su -
`su -`
## Exit from new session created
`exit`
## Add the wheel and dev groups
`groupadd wheel`
`groupadd dev`
## Update the sudoers file to include " %wheel ALL=(ALL) ALL " and " Defaults rootpw "
`vim /etc/sudoers`
## Create the new user
`useradd -m -G wheel,dev -s /bin/bash username`
## Set password for new user
`passwd username`
## Test new user exists
`su username`
## Update firewall with port 22 for ssh and enable
```
ufw status
ufw allow 22
ufw enable
ufw status
```
## Inspect unattended-upgrades settings
`vim /etc/apt/apt.conf.d/50unattended-upgrades`
## Add unattended-upgrades period for auto upgrades " APT::Periodic::Unattended-Upgrade "1"; "
`vim /etc/apt/apt.conf.d/10periodic`
## Update ssh config to disable root login over ssh
`vim /etc/ssh/sshd_config`
## Reboot system to restart all services with the updates
`reboot`
