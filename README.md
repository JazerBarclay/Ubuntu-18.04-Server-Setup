# Ubuntu-18.04-Server-Setup
A basic setup and installation guide for ubuntu server 18.04 on linode
Video: [My First 7 Minutes On An Ubuntu Server - Essential Security for Linux Servers](https://www.youtube.com/watch?v=KjuSf_aPYFg)

## System Core Setup

### First we upgrade the server to the most up to date state using
`apt update && apt -y upgrade && apt -y autoremove`

### then we install some base packages that i make sure are on every installation
`apt -y install vim git curl wget ca-certificates`

### We can use some groups for managing access to certain system folders and more importantly the git repo store
### For this I will be creating the wheel group for root groups and dev groups for developers who may in the future need access to the hooks
`groupadd wheel`
`groupadd dev`

### Update with wheel all all and defaults rootpw
`vim /etc/sudoers`

### Next lets add root to the wheel and dev groups
`usermod -a -G wheel root`
`usermod -a -G dev root`

### I dont want to be logging in as root all the time so i'll create my own user which will also be in the wheel and dev groups
`useradd -m -G wheel,dev -s /bin/bash jazer`

### I want the server to be named after the site it will be hosted on to make itself self explanitory should i need to connect in
`hostnamectl set-hostname hub.tora.tech`

### we will want the firewall to be active and only allowing

### Allow ssh, http and https
```bash
ufw allow 22
ufw allow 80
ufw allow 443
```

### now lets enable the firewall and check the running status
`ufw enable`
`ufw status`

## Postfix & GitLab Installation

### I will be installing postfix and if you want to put this build into a script. This will make the installation part silent using the given mail domain and site type
`debconf-set-selections <<< "postfix postfix/mailname string mail.hub.tora.tech"`
`debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"`

### Now to install postfix
`apt -y install postfix`

### To install gitlab, there is a script available to download from their packages subdomain. I'm piping this script into bash to just run it however you can download and inspect the script first before running it. Usually a good practice
'curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash'

### I will be using letsencrypt for the ssl cert which will secure the site
`apt -y install gitlab-ce letsencrypt`

## Update the domain name for gitlab
`vim /etc/gitlab/gitlab.rb`

### Now to generate the ssl certificate. We want just the cert, to auto agree to the tos and use the given email and register it to hub.tora.tech
`letsencrypt certonly --standalone --agree-tos --no-eff-email --agree-tos --email admin@tora.tech -d hub.tora.tech`

### We will also be creating a dhparams.pem file and that will be going into the /etc/gitlab/ssl folder we are creating here
`mkdir -p /etc/gitlab/ssl`

### So lets create the dhparams.pem with 2048 bit
`pushd /etc/gitlab/ssl`
`openssl dhparam -out /etc/gitlab/ssl/dhparams.pem 2048`

### We only want the owner to have read and write access so we set the ssl folder contents to 600
`chmod 600 /etc/gitlab/ssl/*`

### So the nginx server that runs the gitlab website needs to know where the public,
### private and dhparams files are located in the system so lets update the gitlab.rb file
### Add nginx stuff for ssl
```
# nginx['redirect_http_to_https'] = true
# nginx['ssl_certificate'] = "/etc/letsencrypt/live/hub.tora.tech/fullchain.pem"
# nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/hub.tora.tech/privkey.pem"
# nginx['ssl_dhparam'] = "/etc/gitlab/ssl/dhparams.pem"
```
### we will also need to find git_data_dirs for changing path to the git users home folder
vim /etc/gitlab/gitlab.rb

### Now to update gitlab with all the changes, we will run the reconfigure control command
gitlab-ctl reconfigure

### the git user has been created with the reconfigure and 
### it will need to be a member of the dev group so lets add it
usermod -a -G dev git

### and we will also need to set ownership of the git home directory to the dev group
### as all members of the group will need access
`chown -R git:dev /home/git`
`chmod -R 774 /home/git`

### now to make sure the system is kept up to date
`vim /etc/apt/apt.conf.d/50unattended-upgrades`
### in here you can configure auto update times and if
### the system should send an email if the upgrades fail

### next is the auto upgrades file
`vim /etc/apt/apt.conf.d/10periodic`
```
# APT::Periodic::Update-Package-Lists "1";
# APT::Periodic::Download-Upgradeable-Packages "1";
# APT::Periodic::AutocleanInterval "7";
# APT::Periodic::Unattended-Upgrade "1";
```

### here is where we need to configure the package lists
### autoclean and upgrade intervals
### the numbers all represent the run intervals in days
### 1 being every day and 7 being every week


### Update /etc/ssh/sshd_config and change allow root login to no

## AND NOW

## We should be ready to go to hub.tora.tech and setup the gitlab accounts throught the web browser !!!

`ssh-keygen -t rsa -b 4096`

`"  -f `whoami`@`hostname`  "`
