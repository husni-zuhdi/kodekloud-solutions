#!/usr/bin/env bash

# The System admin team of xFusionCorp Industries has installed a backup agent tool on all app servers.
# As per the tool's requirements they need to create a user with a non-interactive shell.
# Therefore, create a user named john with a non-interactive shell on the App Server 2

# Login as root
sudo su -

# Your username
USER_NAME=john # your_user_name

# Check if username not taken
id $USER_NAME

# If username is not taken
# Add user with non interactive shell
adduser $USER_NAME  -s /sbin/nologin

# Check username is taken
id $USER_NAME
cat /etc/passwd | grep $USER_NAME
