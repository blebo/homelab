#!/bin/bash
source common.sh

[ -z $IP_BRIDGE_INTERFACE ] && { echo "IP_BRIDGE_INTERFACE is not defined" 1>&2 ; exit 1; }
[ -z $IP_GATEWAY ] && { echo "IP_GATEWAY is not defined" 1>&2 ; exit 1; }

# Must match whats in lxc-hosts
LXC_HOST_NAME=qlxc
# renamed interface to qeth0 according to http://forums.debian.net/viewtopic.php?f=19&t=122795
ETH=qeth0

# defines IP_ADDR
vm_get_ip $LXC_HOST_NAME
[ -z $IP_ADDR ] && { echo "IP_ADDR is not defined" 1>&2 ; exit 1; }

# fail if the interface is already configured
if grep -q $ETH /etc/network/interfaces; then
	echo "Detected existing config of $ETH in /etc/network/interfaces"
	exit 2
fi
if grep -q $LXC_HOST_NAME /etc/network/interfaces; then
	echo "Detected existing config of $LXC_HOST_NAME in /etc/network/interfaces"
	exit 2
fi

interfaces_file=/etc/network/interfaces.d/$IP_BRIDGE_INTERFACE.conf
if [ -f $interfaces_file ]; then
	echo "Existing interfaces file found, run rm $interfaces_file"
	exit 2
fi
#TODO: This relies on the existance of /etc/resolv.conf, was it created during install?
cat <<EOF >> $interfaces_file
auto $IP_BRIDGE_INTERFACE
iface $IP_BRIDGE_INTERFACE inet static
    bridge_ports $ETH
    bridge_fd 0
    address $IP_ADDR
    netmask $IP_SUBNET
#       network <network IP here, e.g. 192.168.1.0>
#       broadcast <broadcast IP here, e.g. 192.168.1.255>
    gateway $IP_GATEWAY
    # dns-* options are implemented by the resolvconf package, if installed
    #dns-nameservers 192.168.66.3
    #dns-search quackluster.lan
EOF

service networking restart