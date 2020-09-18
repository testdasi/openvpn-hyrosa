#!/bin/bash

# install static files
mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/static/archive/master.zip" -o /temp/static.zip \
    && unzip /temp/static.zip \
    && rm -f /temp/static.zip \
    && mv /temp/static-master /static

# fix static files for repo-specific stuff
sed -i "s|\/data\/deluge\/watch|\/data\/rtorrent\/watch|g" '/static/config/nzbhydra.yml'
sed -i "s|\/config\/openvpn|\/root\/openvpn|g" '/static/scripts/openvpn.sh'
sed -i "s|\/config\/openvpn|\/root\/openvpn|g" '/static/scripts/set_variables_ovpn_port_proto.sh'

# overwrite static with repo-specific stuff
cp -f /temp/* /static/config/ \
    && rm -rf /temp

# chmod scripts
chmod +x /*.sh
