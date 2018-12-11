#!/bin/bash
apt-get update
apt-get install -y language-pack-en-base software-properties-common python-software-properties nano wget curl git build-essential libxml2 libxml2-dev openssl libssl-dev pkg-config #install needed packages
LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y #add ondrej's repo
apt-get update #after adding new repo, we need to update package versions/information
apt-get install wget nano perl -y
#we are removing new ssl libs and installing older ones
apt-get remove libssl-dev openssl -y
apt-get autoremove -y
apt-get install -y libssl-dev=1.0.2g-1ubuntu4.14 openssl=1.0.2g-1ubuntu4.14
#if this version  of ssl libs are not working, check version with apt-cache policy libssl-dev and apt-cache policy openssl
mkdir /home/flegma
mkdir /home/install-scripts
cd /home/install-scripts
wget --no-check-certificate https://raw.githubusercontent.com/Flegma/eBot-install-script/master/ebot-install.sh && chmod +x ebot-install.sh && ./ebot-install.sh #we need the --no-check-certificate here because we are using old ssl libs and it will fail to verify ssl certificates
#and now ts3 server
wget --no-check-certificate https://files.teamspeak-services.com/releases/server/3.5.0/teamspeak3-server_linux_amd64-3.5.0.tar.bz2 #we need the --no-check-certificate here because we are using old ssl libs and it will fail to verify ssl certificates
tar -xjvf teamspeak3-server_linux_amd64-3.5.0.tar.bz2
mv teamspeak3-server_linux_amd64 /home/flegma/teamspeak
touch /home/flegma/teamspeak/.ts3server_license_accepted
#if you are using sysinit and not systemd, you might want to edit ts3 startup script. use these 3 lines, or just manually edit it (change top lines only)
#wget --no-check-certificate https://raw.githubusercontent.com/Flegma/ts3_startscript_edits/master/ts3_initscript_edit.txt && mv ts3_initscript_edit.txt /home/flegma/teamspeak/ts3_init_edit.txt
#sed -i '1,3d' /home/flegma/teamspeak/ts3server_startscript.sh
#tmp="$(mktemp)" && cat /home/flegma/teamspeak/ts3_init_edit.txt /home/flegma/teamspeak/ts3server_startscript.sh >"$tmp" && mv "$tmp" /home/flegma/teamspeak/ts3server_startscript.sh
ln -s /home/flegma/teamspeak/ts3server_startscript.sh /etc/init.d/teamspeak
#update-rc.d teamspeak defaults
service teamspeak start &>> /home/flegma/teamspeak/teamspeak-output.txt
#and now csgo server scripts
apt-get install dnsutils -y
wget --no-check-certificate https://raw.githubusercontent.com/crazy-max/csgo-server-launcher/master/install.sh && mv install.sh csgo-install.sh && chmod +x csgo-install.sh && ./csgo-install.sh
#DO NOT FORGET to edit the configuration in '/etc/csgo-server-launcher/csgo-server-launcher.conf'
#Then type:
#  '/etc/init.d/csgo-server-launcher create' to install steam and csgo
#  '/etc/init.d/csgo-server-launcher start' to start the csgo server!