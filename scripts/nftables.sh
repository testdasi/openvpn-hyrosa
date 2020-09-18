#!/bin/bash

### Editing ruleset ###
echo '[info] Editing base ruleset'
rm -f /nftables.rules
cp /ruleset.nft /nftables.rules
sed -i "s|_ETH0_NET_|$ETH0_NET|g" '/nftables.rules'
sed -i "s|_HOST_NETWORK_|${HOST_NETWORK}|g" '/nftables.rules'
sed -i "s|_OPENVPN_PROTO_|$OPENVPN_PROTO|g" '/nftables.rules'
sed -i "s|_OPENVPN_PORT_|$OPENVPN_PORT|g" '/nftables.rules'
sed -i "s|_DNS_PORT_|$DNS_PORT|g" '/nftables.rules'
sed -i "s|_DANTE_PORT_|$DANTE_PORT|g" '/nftables.rules'
sed -i "s|_TINYPROXY_PORT_|$TINYPROXY_PORT|g" '/nftables.rules'
sed -i "s|_SAB_PORT_A_|$SAB_PORT_A|g" '/nftables.rules'
sed -i "s|_SAB_PORT_B_|$SAB_PORT_B|g" '/nftables.rules'
sed -i "s|_HYDRA_PORT_|$HYDRA_PORT|g" '/nftables.rules'
sed -i "s|_FLOOD_PORT_|$FLOOD_PORT|g" '/nftables.rules'

### static scripts ###
source /static/scripts/nftables_apply.sh
source /static/scripts/nftables_quick_block_test.sh
