#!/usr/bin/env bash
# We have a requirement where we want to password protect a directory in the Apache web server document root.
# We want to password protect http://<website-url>:<apache_port>/protected URL as per the following requirements
# (you can use any website-url for it like localhost since there are no such specific requirements as of now).
# Setup the same on App server 2 as per below mentioned requirements:
#  a. We want to use basic authentication.
#  b. We do not want to use htpasswd file based authentication.
#     Instead, we want to use PAM authentication, i.e Basic Auth + PAM
#     so that we can authenticate with a Linux user.
#  c. We already have a user mariyam with password TmPcZjtRQx which you need to provide access to
#  d. You can access the website using APP button on the top bar.
# References
# [1] https://www.nbtechsupport.co.in/2021/01/pam-authentication-for-apache-kodekloud.html

# Login as root
sudo su -

# Set username and password
USER_NAME=mariyam
PASSWORD=TmPcZjtRQx

# Install pwauth
yum --enablerepo=epel -y install mod_authnz_external pwauth

# Append this config to /etc/httpd/conf.d/authnz_external.conf
cat <<'EOT' >> /etc/httpd/conf.d/authnz_external.conf
<Directory /var/www/html/protected>
AuthType Basic
AuthName "PAM Authentication"
AuthBasicProvider external
AuthExternal pwauth
require valid-user
</Directory>
EOT

# Create a protected folder under Apache root web server
# And verify the index.html file
mkdir -p /var/www/html/protected
cat /var/www/html/protected/index.html

# Start Apache web server
systemctl start httpd && systemctl status httpd

# Test connection
curl -vv -u $USER_NAME:$PASSWORD http://localhost:8080/protected/
