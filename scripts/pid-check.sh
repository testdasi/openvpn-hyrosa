#!/bin/bash

crashed=0

pidlist=$(pidof stubby)
if [ -z "$pidlist" ]
then
    echo '[warn] stubby crashed, restarting'
    crashed=$(( $crashed + 1 ))
    stubby -g -C /root/stubby/stubby.yml
else
    echo "[info] stubby PID: $pidlist"
fi

pidlist=$(pidof openvpn)
if [ -z "$pidlist" ]
then
    echo '[warn] openvpn crashed, restarting'
    crashed=$(( $crashed + 1 ))
    source /static/scripts/openvpn.sh
else
    echo "[info] openvpn PID: $pidlist"
fi

pidlist=$(pidof danted)
if [ -z "$pidlist" ]
then
    echo '[warn] danted crashed, restarting'
    crashed=$(( $crashed + 1 ))
    danted -D -f /root/dante/danted.conf
else
    echo "[info] danted PID: $pidlist"
fi

pidlist=$(pidof tinyproxy)
if [ -z "$pidlist" ]
then
    echo '[warn] tinyproxy crashed, restarting'
    crashed=$(( $crashed + 1 ))
    tinyproxy -c /root/tinyproxy/tinyproxy.conf
else
    echo "[info] tinyproxy PID: $pidlist"
fi

#pidlist=$(cat /root/sabnzbdplus/sabnzbd.pid)
pidlist=$(pidof python2)
if [ -z "$pidlist" ]
then
    echo '[warn] sabnzbdplus crashed, restarting'
    crashed=$(( $crashed + 1 ))
    sabnzbdplus --daemon --config-file /root/sabnzbdplus/sabnzbdplus.ini --pidfile /root/sabnzbdplus/sabnzbd.pid
else
    echo "[info] sabnzbdplus PID: $pidlist"
fi

pidlist=$(pidof rtorrent)
if [ -z "$pidlist" ]
then
    echo '[warn] rtorrent crashed, restarting'
    crashed=$(( $crashed + 1 ))
    screen -d -m -fa -S rtorrent /usr/bin/rtorrent
else
    echo "[info] rtorrent PID: $pidlist"
fi

pidlist=$(pidof npm)
if [ -z "$pidlist" ]
then
    echo '[warn] flood crashed, restarting'
    crashed=$(( $crashed + 1 ))
    start-stop-daemon --start --background --name flood --chdir /app/flood --exec /app/flood/flood.sh
else
    echo "[info] flood PID: $pidlist"
fi

#pidlist=$(cat /root/nzbhydra2/nzbhydra2.pid)
pidlist=$(pidof nzbhydra2)
if [ -z "$pidlist" ]
then
    echo '[warn] nzbhydra2 crashed, restarting'
    crashed=$(( $crashed + 1 ))
    /app/nzbhydra2/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /root/nzbhydra2 --pidfile /root/nzbhydra2/nzbhydra2.pid
else
    echo "[info] nzbhydra2 PID: $pidlist"
fi

pidlist=$(pidof python3)
if [ -z "$pidlist" ]
then
    echo '[warn] WebUI launcher crashed, restarting'
    crashed=$(( $crashed + 1 ))
    start-stop-daemon --start --background --name launcher --chdir /app/launcher --exec /app/launcher/launcher-python3.sh
else
    echo "[info] WebUI launcher PID: $pidlist"
fi
