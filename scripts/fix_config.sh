#!/bin/bash

update-locale LANG=$LANG
echo '[info] language fixed.'

mkdir -p /config/stubby \
    && cp -n /temp/stubby.yml /config/stubby/
sed -i "s|  - 0\.0\.0\.0\@53|  - 0\.0\.0\.0\@$DNS_PORT|g" '/config/stubby/stubby.yml'
echo '[info] stubby fixed.'

mkdir -p /config/dante \
    && cp -n /temp/danted.conf /config/dante/
sed -i "s|internal: eth0 port=1080|internal: eth0 port=$DANTE_PORT|g" '/config/dante/danted.conf'
echo '[info] danted fixed.'

mkdir -p /config/tinyproxy \
    && cp -n /temp/tinyproxy.conf /config/tinyproxy/
sed -i "s|Port 8080|Port $TINYPROXY_PORT|g" '/config/tinyproxy/tinyproxy.conf'
sed -i "s|upstream socks5 localhost:1080|upstream socks5 $ETH0_IP:$DANTE_PORT|g" '/config/tinyproxy/tinyproxy.conf'
echo '[info] tinyproxy fixed.'

mkdir -p /config/sabnzbdplus \
    && cp -n /temp/sabnzbdplus.ini /config/sabnzbdplus/ \
    && mkdir -p /data/sabnzbdplus/watch \
    && mkdir -p /data/sabnzbdplus/incomplete \
    && mkdir -p /data/sabnzbdplus/complete \
    && mkdir -p /data/sabnzbdplus/script
sed -i "s|port = 8080|port = $SAB_PORT_A|g" '/config/sabnzbdplus/sabnzbdplus.ini'
sed -i "s|https_port = 8090|https_port = $SAB_PORT_B|g" '/config/sabnzbdplus/sabnzbdplus.ini'
echo '[info] sabnzbdplus fixed.'

mkdir -p /config/deluge-web \
    && cp -n /temp/deluge.conf /config/deluge-web/core.conf \
    && cp -n /temp/deluge-web.conf /config/deluge-web/web.conf \
    && mkdir -p /data/deluge/watch \
    && mkdir -p /data/deluge/incomplete \
    && mkdir -p /data/deluge/complete \
    && mkdir -p /data/deluge/torrent
sed -i "s|\"port\": 8112|\"port\": $DELUGE_PORT|g" '/config/deluge-web/web.conf'
echo '[info] deluge fixed.'


mkdir -p /config/nzbhydra2 \
    && cp -n /temp/nzbhydra.yml /config/nzbhydra2/
sed -i "s|port: 5076|port: $HYDRA_PORT|g" '/config/nzbhydra2/nzbhydra.yml'
sed -i "s|127\.0\.0\.1:8080|127\.0\.0\.1:$SAB_PORT_A|g" '/config/nzbhydra2/nzbhydra.yml'
echo '[info] nzbhydra2 fixed.'
