#!/usr/bin/env bash
# The Nautilus team doesn't want its data to be accessed by any of the other groups/teams
# due to security reasons and want their data to be strictly accessed by the sysadmin
# group of the team.
# Setup a collaborative directory /sysadmin/data on Nautilus App 3 server in Stratos Datacenter.
# The directory should be group owned by the group sysadmin and
# the group should own the files inside the directory.
# The directory should be read/write/execute to the group owners,
# and others should not have any access.

# Login as root
sudo su -

# Set folder and groupname
export FOLDER="/sysadmin/data"
export GROUP_NAME="sysadmin"

# Create the folder
mkdir -p $FOLDER

# Change ownership of /sysadmin/data and files inside
chgrp -R $GROUP_NAME $FOLDER

# Grant read/write/execute to group_name
chmod -R 2770 $FOLDER
