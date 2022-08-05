#!/usr/bin/env bash

sudo su -
export NGINX_PORT=your_nginx_port
export APACHE_PORT=your_apache_port
iptables -L

iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport $NGINX_PORT -j ACCEPT
iptables -A INPUT -p tcp --dport $APACHE_PORT -j DROP

iptables-save > /etc/sysconfig/iptables

yum install iptables-services -y
systemctl start iptables
systemctl enable iptables
