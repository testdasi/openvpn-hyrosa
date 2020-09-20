#!/bin/bash

### Kill of ovpn not found ###
if [[ -f "/root/openvpn/openvpn.ovpn" ]]
then
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
    #screen -d -m -fa -S rtorrent_flood bash /rtorrent_flood.sh
    screen -d -m -fa -S rtorrent /usr/bin/rtorrent
    cd /app/flood \
        && screen -d -m -fa -S flood npm start &> /dev/null

    ### nzbhydra2
    echo ''
    echo "[info] Run nzbhydra2 in background on port $HYDRA_PORT"
    /app/nzbhydra2/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /root/nzbhydra2 --pidfile /root/nzbhydra2/nzbhydra2.pid

    ### GUI launcher
    echo ''
    echo "[info] Run WebUI launcher in background at $LAUNCHER_IP:$LAUNCHER_PORT"
    screen -d -m -fa -S launcher /app/launcher/launcher-python3.sh

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
            cd /app/flood \
                && screen -d -m -fa -S flood npm start &> /dev/null
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
            screen -d -m -fa -S launcher /app/launcher/launcher-python3.sh
        else
            echo "[info] WebUI launcher PID: $pidlist"
        fi
        
        # reset wait time if something crashed, otherwise double the wait time till next healthcheck
        if (( $crashed > 0 ))
        then
            sleep_time=$(( $crashed * 10 ))
            crashed=0
        else
            sleep_time=$(( $sleep_time * 2 ))
            # restrict wait time to within 3600s i.e. 1hr
            if (( $sleep_time > 3600 ))
            then
                sleep_time=3600
            fi
        fi
    done
else
    echo '[CRITICAL] Config file not found, quitting...'
fi
