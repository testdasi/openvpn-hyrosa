#!/bin/bash

update-locale LANG=$LANG
echo '[info] language fixed.'

mkdir -p /root/.getdns \
    && cp -n /static/config/.profile /root/ \
    && cp -n /static/config/.bashrc /root/ \
    && touch /root/.bash_history
echo '[info] root folder fixed.'

cp -f /static/config/index.html /app/launcher/
sed -i "s|192.168.1.1|$LAUNCHER_IP|g" '/app/launcher/index.html'
sed -i "s|server 8000|server $LAUNCHER_PORT|g" '/app/launcher/launcher-python3.sh'
sed -i "s|Server 8000|Server $LAUNCHER_PORT|g" '/app/launcher/launcher-python2.sh'
sed -i "s|:8080|:$SAB_PORT_A|g" '/app/launcher/index.html'
sed -i "s|:5076|:$HYDRA_PORT|g" '/app/launcher/index.html'
sed -i "s|:3000|:$FLOOD_PORT|g" '/app/launcher/index.html'
echo '[info] launcher fixed.'

### static scripts ###
source /static/scripts/fix_config_stubby.sh
source /static/scripts/fix_config_dante.sh
source /static/scripts/fix_config_tinyproxy.sh
source /static/scripts/fix_config_sabnzbdplus.sh
source /static/scripts/fix_config_rtorrent.sh
source /static/scripts/fix_config_flood.sh
source /static/scripts/fix_config_nzbhydra2.sh
