#!/bin/bash

# install static files
mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/static/archive/master.zip" -o /temp/static.zip \
    && unzip /temp/static.zip \
    && rm -f /temp/static.zip \
    && mv /temp/static-master /static

# chmod scripts
chmod +x /*.sh
