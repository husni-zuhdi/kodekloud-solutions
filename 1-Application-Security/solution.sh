#!/usr/bin/env bash

# Login as root
sudo su -

# Set environment variables
export NGINX_PORT=your_nginx_port
export APACHE_PORT=your_apache_port

# Check firewall (?)
iptables -L

# Add changes to firewalls
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport $NGINX_PORT -j ACCEPT
iptables -A INPUT -p tcp --dport $APACHE_PORT -j DROP

# Save our iptables config to file
# so we can use it when the system is rebooted
iptables-save > /etc/sysconfig/iptables

# Install iptables-services to re-apply our iptables config
# when the system is rebooted
yum install iptables-services -y
systemctl start iptables
systemctl enable iptables
