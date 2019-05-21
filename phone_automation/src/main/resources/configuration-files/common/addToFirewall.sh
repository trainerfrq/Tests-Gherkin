#!/bin/bash
# call me like ./addToFirewall.sh catsHazelcast 5701

interfaceName="$1_RL"
port=$2

iptables -A INPUT_direct -i macvlanmgt0 -p tcp -m tcp --dport $port -m state --state NEW -m recent --set --name native-xvp-$interfaceName --mask 255.255.255.255 --rsource
iptables -A INPUT_direct -i macvlanmgt0 -p tcp -m tcp --dport $port -m state --state NEW -m recent --update --seconds 1 --hitcount 255 --rttl --name native-xvp-$interfaceName --mask 255.255.255.255 --rsource -m limit --limit 5/min -j LOG
iptables -A INPUT_direct -i macvlanmgt0 -p tcp -m tcp --dport $port -m state --state NEW -m recent --update --seconds 1 --hitcount 255 --rttl --name native-xvp-$interfaceName --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT_direct -i macvlanmgt0 -p tcp -m tcp --dport $port -m state --state NEW -j ACCEPT