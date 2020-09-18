#!/bin/bash

# install static files
mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/static/archive/master.zip" -o /temp/static.zip \
    && unzip /temp/static.zip \
    && rm -f /temp/static.zip \
    && mv /temp/static-master /static

# overwrite static with repo-specific stuff
cp -f /temp/* /static/config/ \
    && rm -rf /temp

# fix static files for repo-specific stuff
sed -i "s|\/data\/deluge\/watch|\/data\/rtorrent\/watch|g" '/static/config/nzbhydra.yml'
sed -i "s|\/etc\/openvpn|\/root\/openvpn|g" '/static/scripts/openvpn.sh'
sed -i "s|\/etc\/openvpn|\/root\/openvpn|g" '/static/scripts/set_variables_ovpn_port_proto.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_stubby.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_dante.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_tinyproxy.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_sabnzbdplus.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_rtorrent.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_flood.sh'
sed -i "s|\/etc\/|\/root\/|g" '/static/scripts/fix_config_nzbhydra2.sh'

# chmod scripts
chmod +x /*.sh
