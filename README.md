# ebot_ts3_csgo_install
Installation script for EBOT, CS:GO and TS3 server on Ubuntu 16.04 LTS (updated and tested 17.04.2021)

You need to run it with root:
```
su -c "bash <(wget -qO- https://raw.githubusercontent.com/Flegma/ebot_ts3_csgo_install/master/install.sh)"
```

If something fails, its probably due to openssl and libssl-dev packages being updated in the Ubuntu repository. As you can see in this line 
https://github.com/Flegma/ebot_ts3_csgo_install/blob/master/install.sh#L10
we are installing particular version, that might get updated sometimes. Please contact me at Flegma (at) gmail. com or check versions with 
```
apt-cache policy libssl-dev
apt-cache policy openssl
```
and change line 10 with respective values. 

I will make this process automatic when i get more time. 
