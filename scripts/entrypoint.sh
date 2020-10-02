#!/bin/bash

### Only run process if ovpn found ###
if [[ -f "/root/openvpn/openvpn.ovpn" ]]
then
    echo '[info] Config file detected...'
    ### Set various variable values ###
    echo ''
    echo '[info] Setting variables'
    source /set_variables.sh
    echo '[info] All variables set'

    ### Fixing config files ###
    echo ''
    echo '[info] Fixing configs'
    source /fix_config.sh
    echo '[info] All configs fixed'

    ### Stubby DNS-over-TLS ###
    echo ''
    echo "[info] Run stubby in background on port $DNS_PORT"
    stubby -g -C /root/stubby/stubby.yml
    ipnaked=$(dig +short myip.opendns.com @208.67.222.222)
    echo "[warn] Your ISP public IP is $ipnaked"

    ### nftables ###
    echo ''
    echo '[info] Set up nftables rules'
    source /nftables.sh
    echo '[info] All rules created'

    ### OpenVPN ###
    echo ''
    echo "[info] Setting up OpenVPN tunnel"
    source /static/scripts/openvpn.sh
    echo '[info] Done'

    ### Dante SOCKS proxy to VPN ###
    echo ''
    echo "[info] Run danted in background on port $DANTE_PORT"
    danted -D -f /root/dante/danted.conf

    ### Tinyproxy HTTP proxy to VPN ###
    echo ''
    echo "[info] Run tinyproxy in background with no log on port $TINYPROXY_PORT"
    tinyproxy -c /root/tinyproxy/tinyproxy.conf

    ### sabnzbdplus
    echo ''
    echo "[info] Run sabnzbdplus in background on HTTP port $SAB_PORT_A and HTTPS port $SAB_PORT_B"
    sabnzbdplus --daemon --config-file /root/sabnzbdplus/sabnzbdplus.ini --pidfile /root/sabnzbdplus/sabnzbd.pid

    ### rtorrent + flood
    echo ''
    echo "[info] Run rtorrent and flood in background on port $FLOOD_PORT"
    screen -d -m -fa -S rtorrent /usr/bin/rtorrent
    start-stop-daemon --start --background --name flood --chdir /app/flood --exec /app/flood/flood.sh

    ### nzbhydra2
    echo ''
    echo "[info] Run nzbhydra2 in background on port $HYDRA_PORT"
    /app/nzbhydra2/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /root/nzbhydra2 --pidfile /root/nzbhydra2/nzbhydra2.pid

    ### GUI launcher
    echo ''
    echo "[info] Run WebUI launcher in background at $LAUNCHER_IP:$LAUNCHER_PORT"
    start-stop-daemon --start --background --name launcher --chdir /app/launcher --exec /app/launcher/launcher-python3.sh

    ### Infinite loop to stop docker from stopping ###
    sleep_time=10
    crashed=0
    while true
    do
        echo ''
        echo "[info] Wait $sleep_time seconds before next healthcheck..."
        sleep $sleep_time
        
        iphiden=$(dig +short myip.opendns.com @208.67.222.222)
        echo "[info] Your VPN public IP is $iphiden"
        
        source /static/scripts/pid-check.sh
        
        # reset wait time if something crashed, otherwise double the wait time till next healthcheck
        if (( $crashed > 0 ))
        then
            sleep_time=$(( $crashed * 10 ))
            crashed=0
        else
            sleep_time=$(( $sleep_time * 2 ))
            # restrict wait time to within 3600s i.e. 1hr
            if (( $sleep_time > 360 ))
            then
                sleep_time=360
            fi
        fi
    done
else
    echo '[CRITICAL] Config file not found, quitting...'
fi
