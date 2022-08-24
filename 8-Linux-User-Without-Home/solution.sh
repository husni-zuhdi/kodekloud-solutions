#!/usr/bin/env bash
# The system admins team of xFusionCorp Industries has set up a new tool on all app servers,
# as they have a requirement to create a service user account that will be used by that tool.
# They are finished with all apps except for App Server 3 in Stratos Datacenter.

# Create a user named javed in App Server 3 without a home directory.

# Login as root
sudo su -

# Your username
USER_NAME=javed # your_user_name

# Check if username not taken
id $USER_NAME

# If username is not taken
# Add user without home 
useradd --no-create-home $USER_NAME

# Check username is taken
id $USER_NAME
cat /etc/passwd | grep $USER_NAME

