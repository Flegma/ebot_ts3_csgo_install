#!/bin/bash
apt-get update
apt-get install -y language-pack-en-base software-properties-common nano wget curl git build-essential libxml2 libxml2-dev openssl libssl-dev pkg-config #install needed packages
LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y #add ondrej's repo
apt-get update #after adding new repo, we need to update package versions/information
#we are removing new ssl libs and installing older ones
apt-get remove libssl-dev openssl -y
apt-get autoremove -y
#DODATI REPO ZA STARI OPENSSL I LIBSSL-DEV
echo '#add older ubuntu 16.04 repository' >> /etc/apt/sources.list
echo 'deb http://security.ubuntu.com/ubuntu xenial-security main' >> /etc/apt/sources.list
apt-get update
apt-get install -y libssl-dev=1.0.2g-1ubuntu4.20 openssl=1.0.2g-1ubuntu4.20
#if this version  of ssl libs are not working, check version with apt-cache policy libssl-dev and apt-cache policy openssl
mkdir /home/flegma
mkdir /home/install-scripts
cd /home/install-scripts
wget --no-check-certificate https://raw.githubusercontent.com/Flegma/eBot-install-script/ubuntu-20.04/ebot-install.sh && chmod +x ebot-install.sh && ./ebot-install.sh #we need the --no-check-certificate here because we are using old ssl libs and it will fail to verify ssl certificates
rm -rf /home/ebot/ebot-web/web/installation #we need to remove installation directory in order for ebot to work
#and now ts3 server
wget --no-check-certificate https://files.teamspeak-services.com/releases/server/3.13.6/teamspeak3-server_linux_amd64-3.13.6.tar.bz2 #we need the --no-check-certificate here because we are using old ssl libs and it will fail to verify ssl certificates
tar -xjvf teamspeak3-server_linux_amd64-3.13.6.tar.bz2
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
# todo: create csgo server (add gslt key when asked) and download/unpack/copy eBot Csay plugin - http://www.esport-tools.net/download/CSay-CSGO.zip
chown -R www-data:www-data /home/ebot
chmod -R 777 /home/ebot/ebot-csgo/demos
sed -i '/\[mysqld\]/a sql-mode=""' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '/\[mysqld\]/a innodb_flush_log_at_trx_commit = 2' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
#shutdown -r now
