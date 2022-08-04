#!/usr/bin/env bash

# We have some users on all app servers in Stratos Datacenter.
# Some of them have been assigned some new roles and responsibilities,
# therefore their users need to be upgraded with sudo access so that they can perform admin level tasks.
# a. Provide sudo access to user mariyam on all app servers.
# b. Make sure you have set up password-less sudo for the user.

# Login to root
sudo su -

# Change to suit your username
export USER_NAME=mariyam #your_user_name
sudo echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
