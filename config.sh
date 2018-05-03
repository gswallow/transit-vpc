#!/bin/bash

ENI_ADDR=100.64.64.10
LOCAL_PREFIX=100.64.64.0/21
REMOTE_PREFIX=172.16.0.0/16
VPN_ID=vpn-ebe135dc
LOCAL_BGP_AS=65100
REMOTE_BGP_AS=65110

TUN1_INTERFACE_LOCAL_ADDR=169.254.59.150
TUN1_INTERFACE_REMOTE_ADDR=169.254.59.149
TUN1_PEER_ADDR=18.216.212.249
TUN1_INTERFACE_CIDR=30
TUN1_SHARED_SECRET=lBx1h3CVgKXJ1Cm47Q4WQhrVUDj54oHN

TUN2_INTERFACE_LOCAL_ADDR=169.254.59.106
TUN2_INTERFACE_REMOTE_ADDR=169.254.59.105
TUN2_PEER_ADDR=52.14.142.186
TUN2_INTERFACE_CIDR=30
TUN2_SHARED_SECRET=l7ghyGq6HnOpL2JUrdiHG0jtRCxQmoba

cat <<EOF
conf

# Globals

set protocols bgp $LOCAL_BGP_AS network $LOCAL_PREFIX
set protocols bgp $LOCAL_BGP_AS parameters router-id $ENI_ADDR
set protocols static interface-route $LOCAL_PREFIX next-hop-interface eth0
set vpn ipsec ipsec-interfaces interface eth0
set vpn ipsec nat-traversal enable

# Tunnel 1

set interfaces vti vti0 description ${VPN_ID}-1
set interfaces vti vti0 address ${TUN1_INTERFACE_LOCAL_ADDR}/${TUN1_INTERFACE_CIDR}
set interfaces vti vti0 mtu 1436
set interfaces vti vti0 ip source-validation disable

set vpn ipsec ike-group ${VPN_ID}-1 proposal 1
set vpn ipsec ike-group ${VPN_ID}-1 proposal 1 encryption aes128
set vpn ipsec ike-group ${VPN_ID}-1 proposal 1 hash sha1
set vpn ipsec ike-group ${VPN_ID}-1 ikev2-reauth no
set vpn ipsec ike-group ${VPN_ID}-1 key-exchange ikev1
set vpn ipsec ike-group ${VPN_ID}-1 proposal 1 dh-group 2
set vpn ipsec ike-group ${VPN_ID}-1 lifetime 28800
set vpn ipsec ike-group ${VPN_ID}-1 dead-peer-detection action restart
set vpn ipsec ike-group ${VPN_ID}-1 dead-peer-detection interval 15
set vpn ipsec ike-group ${VPN_ID}-1 dead-peer-detection timeout 120
set vpn ipsec esp-group ${VPN_ID}-1 proposal 1 encryption aes128
set vpn ipsec esp-group ${VPN_ID}-1 proposal 1 hash sha1
set vpn ipsec esp-group ${VPN_ID}-1 lifetime 3600
set vpn ipsec esp-group ${VPN_ID}-1 pfs dh-group2
set vpn ipsec esp-group ${VPN_ID}-1 compression disable
set vpn ipsec site-to-site peer $TUN1_PEER_ADDR authentication mode pre-shared-secret
set vpn ipsec site-to-site peer $TUN1_PEER_ADDR ikev2-reauth inherit 
edit vpn ipsec site-to-site peer $TUN1_PEER_ADDR
set authentication pre-shared-secret $TUN1_SHARED_SECRET
set authentication id $ENI_ADDR
set authentication remote-id $TUN1_PEER_ADDR
set ike-group ${VPN_ID}-1
set local-address $ENI_ADDR
set vti bind vti0
set vti esp-group ${VPN_ID}-1
top

set protocols bgp $LOCAL_BGP_AS neighbor $TUN1_INTERFACE_REMOTE_ADDR ebgp-multihop 2
set protocols bgp $LOCAL_BGP_AS neighbor $TUN1_INTERFACE_REMOTE_ADDR remote-as $REMOTE_BGP_AS
set protocols bgp $LOCAL_BGP_AS neighbor $TUN1_INTERFACE_REMOTE_ADDR update-source $TUN1_INTERFACE_LOCAL_ADDR

# Tunnel 2 

set interfaces vti vti1 description ${VPN_ID}-2
set interfaces vti vti1 address ${TUN2_INTERFACE_LOCAL_ADDR}/${TUN2_INTERFACE_CIDR}
set interfaces vti vti1 mtu 1436
set interfaces vti vti1 ip source-validation disable

set vpn ipsec ike-group ${VPN_ID}-2 proposal 1
set vpn ipsec ike-group ${VPN_ID}-2 proposal 1 encryption aes128
set vpn ipsec ike-group ${VPN_ID}-2 proposal 1 hash sha1
set vpn ipsec ike-group ${VPN_ID}-2 ikev2-reauth no
set vpn ipsec ike-group ${VPN_ID}-2 key-exchange ikev1
set vpn ipsec ike-group ${VPN_ID}-2 proposal 1 dh-group 2
set vpn ipsec ike-group ${VPN_ID}-2 lifetime 28800
set vpn ipsec ike-group ${VPN_ID}-1 dead-peer-detection action restart
set vpn ipsec ike-group ${VPN_ID}-2 dead-peer-detection interval 15
set vpn ipsec ike-group ${VPN_ID}-2 dead-peer-detection timeout 120
set vpn ipsec esp-group ${VPN_ID}-2 proposal 1 encryption aes128
set vpn ipsec esp-group ${VPN_ID}-2 proposal 1 hash sha1
set vpn ipsec esp-group ${VPN_ID}-2 lifetime 3600
set vpn ipsec esp-group ${VPN_ID}-2 pfs dh-group2
set vpn ipsec esp-group ${VPN_ID}-2 compression disable
set vpn ipsec site-to-site peer $TUN2_PEER_ADDR authentication mode pre-shared-secret
edit vpn ipsec site-to-site peer $TUN2_PEER_ADDR
set authentication pre-shared-secret $TUN2_SHARED_SECRET
set ike-group ${VPN_ID}-2
set local-address $ENI_ADDR
set vti bind vti1
set vti esp-group ${VPN_ID}-2
top

set protocols bgp $LOCAL_BGP_AS neighbor $TUN2_INTERFACE_REMOTE_ADDR ebgp-multihop 2
set protocols bgp $LOCAL_BGP_AS neighbor $TUN2_INTERFACE_REMOTE_ADDR remote-as $REMOTE_BGP_AS
set protocols bgp $LOCAL_BGP_AS neighbor $TUN2_INTERFACE_REMOTE_ADDR update-source $TUN2_INTERFACE_LOCAL_ADDR

commit
save
EOF
