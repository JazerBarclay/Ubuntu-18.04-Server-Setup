# Ubuntu-18.04-Server-Setup
A basic setup and installation guide for ubuntu server 18.04 on linode<br>
Video: [My First 7 Minutes On An Ubuntu Server - Essential Security for Linux Servers](https://www.youtube.com/watch?v=KjuSf_aPYFg)<br>
To run the installation script, run
```
# Download script
wget https://raw.githubusercontent.com/jazerbarclay/Ubuntu-18.04-Server-Setup/master/install.sh
# Make it runnable
chmod +x install.sh
# Run script with user and domain 
# Note: password for new account asked on run
sudo ./install.sh [your_username] [your.domain.name]
```

## Make sure the root password is set
You want to run this if you have already got a profile and have yet to setup the root password
```
passwd
```

## Update, Upgrade and Remove old
Since we are on a clean installation , we can run a dist-upgrade which will install new files for the installed packages.
Check out this link for the difference between upgrade and dist-upgrade https://askubuntu.com/a/226213
```
apt update && apt -y dist-upgrade && apt -y autoremove
```

## Install useful and vital packages
Vim, curl and git are very useful when needing to download, edit and pull repositories to your server. Unattended upgrades, fail2ban and ubuntu firewall are vital to ensure the system is secure against attackers and keeping the system up to date when not being adminstered
```
apt -y install vim curl git git-core unattended-upgrades fail2ban ufw
```

## Set the hostname
Sets the hostname of the system.
```
hostnamectl set-hostname example.com
```

## Test change using su -
This will create a new session with the updated hostname so we can make sure the system accepted the change.
```
su -
```

## Exit from new session created
This will return us to the session we are making changes from.
```
exit
```

## Add the wheel and dev groups
I add the wheel group back for sanity reasons and a dev group for if I have another developer with ssh access to the system.
```
groupadd wheel
groupadd dev
```

## Update the sudoers file to include " %wheel ALL=(ALL) ALL " and " Defaults rootpw "
I add the new wheel group back to the sudoers file. Defaults rootpw will make all sudo commands require the root password rather than the users password. I set this on servers for a separate level of security.
```
vim /etc/sudoers
```

## Create the new user
I create a new user account if there is only a root user with the wheel and dev groups
```
useradd -m -G wheel,dev -s /bin/bash username
```

## Set password for new user
When we disable root ssh login, we could lock ourselves out if we dont set a password for this user
```
passwd username
```

## Set the user home to 700
Set the user home to read, write and execute for only the user
```
chmod 700 -R /home/username
```

## Test new user exists
We can use su with the username to login to the new user we created and `exit` to return
```
su username
```

## Update firewall with port 22 for ssh and enable
Status check the state of the firewall. We will open port 22 for ssh and enable the service. We can then check the status again to ensure the service is working.
```
ufw status
ufw allow 22
ufw enable
ufw status
```

## Inspect unattended-upgrades settings
We can enable auto updates with restarts by uncommenting the line `//Unattended-Upgrade::Automatic-Reboot "false";` and setting it to true. We can also set a reboot time with the line `//Unattended-Upgrade::Automatic-Reboot-Time "02:00";`
```
vim /etc/apt/apt.conf.d/50unattended-upgrades
```

## Add unattended-upgrades period for auto upgrades 
We can add the line `APT::Periodic::Unattended-Upgrade "1";` to the bottom of the file for enabling unattended upgrades
```
vim /etc/apt/apt.conf.d/10periodic
```

## Update ssh config to disable root login over ssh
We can change the line `PermitRootLogin yes` to `PermitRootLogin no` to disable root login over ssh
```
vim /etc/ssh/sshd_config
```

## Reboot system to restart all services with the updates
```
reboot
```

