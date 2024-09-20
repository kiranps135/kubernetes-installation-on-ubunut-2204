#!/bin/bash

# Install HAproxy
apt update && apt install -y haproxy

# Define the HAProxy config file location
HAPROXY_CONFIG="/etc/haproxy/haproxy.cfg"

#LB IP
LB_IP=<LB-IP>
# Retrieve NEW_NAME and NEW_IP for masterserver1 from /etc/hosts
NEW_master1=<Control-master1-hostname>
NEW_IP1=<Control-master1-IP>

# Retrieve NEW_NAME and NEW_IP for masterserver2 from /etc/hosts
NEW_master2=<Control-master2-hostname>
NEW_IP2=<Control-master2-IP>

# Configuration snippet to add
CONFIG_HAPROXY=$(cat <<EOF
frontend kubernetes
    bind ${LB_IP}:6443
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server ${NEW_master1} ${NEW_IP1}:6443 check fall 3 rise 2
    server ${NEW_master2} ${NEW_IP2}:6443 check fall 3 rise 2
EOF
)

echo "$CONFIG_HAPROXY" | sudo tee -a $HAPROXY_CONFIG > /dev/null

echo "Configuration snippet added to $HAPROXY_CONFIG"

# starting and enabling service

echo "Starting & enabling HA-Proxy service"

systemctl restart haproxy

systemctl enable haproxy
