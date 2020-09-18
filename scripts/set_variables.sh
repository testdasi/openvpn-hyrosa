#!/bin/bash

### DNS and DoT ports are fixed ###
echo '[info] Set various ports to docker variables'
LAUNCHER_PORT=${LAUNCHER_GUI_PORT}
LAUNCHER_IP=${SERVER_IP}
DNS_PORT=${DNS_SERVER_PORT}
DANTE_PORT=${SOCKS_PROXY_PORT}
TINYPROXY_PORT=${HTTP_PROXY_PORT}
SAB_PORT_A=${USENET_HTTP_PORT}
SAB_PORT_B=${USENET_HTTPS_PORT}
FLOOD_PORT=${TORRENT_GUI_PORT}
HYDRA_PORT=${SEARCHER_GUI_PORT}
# DoT port is fixed due to TLS protocol
DOT_PORT=853

### static scripts ###
source /static/scripts/set_variables_ovpn_port_proto.sh
source /static/scripts/set_variables_eth0.sh
