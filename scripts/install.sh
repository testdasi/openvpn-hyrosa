#!/bin/bash

# install deluge and deluge-web
apt-get -y update \
    && apt-get -y install deluged deluge-web

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

# chmod scripts
chmod +x /*.sh
