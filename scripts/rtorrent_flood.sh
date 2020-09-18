#!/bin/bash

while true
do
    rtorrent_pidlist=$(pidof /usr/bin/rtorrent)
    if [ -z "$rtorrent_pidlist" ]
    then
        screen -d -m -fa -S rtorrent /usr/bin/rtorrent
    fi
    
    flood_pidlist=$(pidof npm)
    if [ -z "$flood_pidlist" ]
    then
        cd /app/flood \
        && screen -d -m -fa -S flood npm start
    fi
    
    sleep 600s
done
