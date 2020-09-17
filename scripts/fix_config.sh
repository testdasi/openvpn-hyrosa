#!/bin/bash

update-locale LANG=$LANG
echo '[info] language fixed.'

mkdir -p /root/.getdns \
    && cp -n /temp/.profile /root/ \
    && cp -n /temp/.bashrc /root/ \
    && touch /root/.bash_history
echo '[info] root folder fixed.'

mkdir -p /root/stubby \
    && cp -n /temp/stubby.yml /root/stubby/
sed -i "s|  - 0\.0\.0\.0\@53|  - 0\.0\.0\.0\@$DNS_PORT|g" '/root/stubby/stubby.yml'
echo '[info] stubby fixed.'

mkdir -p /root/dante \
    && cp -n /temp/danted.conf /root/dante/
sed -i "s|internal: eth0 port=1080|internal: eth0 port=$DANTE_PORT|g" '/root/dante/danted.conf'
echo '[info] danted fixed.'

mkdir -p /root/tinyproxy \
    && cp -n /temp/tinyproxy.conf /root/tinyproxy/
sed -i "s|Port 8080|Port $TINYPROXY_PORT|g" '/root/tinyproxy/tinyproxy.conf'
sed -i "s|upstream socks5 localhost:1080|upstream socks5 $ETH0_IP:$DANTE_PORT|g" '/root/tinyproxy/tinyproxy.conf'
echo '[info] tinyproxy fixed.'

mkdir -p /root/sabnzbdplus \
    && cp -n /temp/sabnzbdplus.ini /root/sabnzbdplus/ \
    && mkdir -p /data/sabnzbdplus/watch \
    && mkdir -p /data/sabnzbdplus/incomplete \
    && mkdir -p /data/sabnzbdplus/complete \
    && mkdir -p /data/sabnzbdplus/script
sed -i "s|port = 8080|port = $SAB_PORT_A|g" '/root/sabnzbdplus/sabnzbdplus.ini'
sed -i "s|https_port = 8090|https_port = $SAB_PORT_B|g" '/root/sabnzbdplus/sabnzbdplus.ini'
echo '[info] sabnzbdplus fixed.'

mkdir -p /root/rtorrent/session \
    && rm -rf /root/rtorrent/session/* \
    && cp -n /temp/.rtorrent.rc /root/ \
    && mkdir -p /data/rtorrent/watch \
    && mkdir -p /data/rtorrent/incomplete \
    && mkdir -p /data/rtorrent/complete \
    && mkdir -p /data/rtorrent/torrent
echo '[info] rtorrent fixed.'

mkdir -p /root/rtorrent/flood_db \
    && cp -n /temp/flood.db /root/rtorrent/flood_db/users.db
sed -i "s|\.\/server\/db\/|\/root\/rtorrent\/flood_db|g" '/app/flood/config.js'
sed -i "s|127\.0\.0\.1|0\.0\.0\.0|g" '/app/flood/config.js'
sed -i "s|3000|$FLOOD_PORT|g" '/app/flood/config.js'
echo '[info] flood fixed.'

mkdir -p /root/nzbhydra2 \
    && cp -n /temp/nzbhydra.yml /root/nzbhydra2/
sed -i "s|port: 5076|port: $HYDRA_PORT|g" '/root/nzbhydra2/nzbhydra.yml'
sed -i "s|127\.0\.0\.1:8080|127\.0\.0\.1:$SAB_PORT_A|g" '/root/nzbhydra2/nzbhydra.yml'
echo '[info] nzbhydra2 fixed.'
