#!/usr/bin/env bash
# One of the Nautilus developers has copied confidential data on the jump host in Stratos DC.
# That data must be copied to one of the app servers.
# Because developers do not have access to app servers, they asked the system admins team to accomplish the task for them.
# Copy /tmp/nautilus.txt.gpg file from jump server to App Server 3 at location /home/opt.

################ IN THE JUMP HOST SERVER ################
# Variables
export SRCPATH="/tmp/nautilus.txt.gpg"
export DESTPATH="/home/opt/nautilus.txt.gpg"
export DESTUSER="banner"
export DESTSERVER="stapp03"

# Execute Remote Copy
# Input your destination server password
scp $SRCPATH $DESTUSER@$DESTSERVER:$DESTPATH

# Verify the file
ssh $DESTUSER@$DESTSERVER
# Input your password
ls $DESTPATH
