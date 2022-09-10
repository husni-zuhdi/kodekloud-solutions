#!/usr/bin/env bash
# The system admins team of xFusionCorp Industries needs to deploy
# a new application on App Server 3 in Stratos Datacenter.
# They have some pre-requites to get ready that server for application deployment.
# Prepare the server as per requirements shared below:
# * Install and configure nginx on App Server 3.
# * On App Server 3 there is a self signed SSL certificate and key present
#   at location /tmp/nautilus.crt and /tmp/nautilus.key. Move them to some
#   appropriate location and deploy the same in Nginx.
# * Create an index.html file with content Welcome! under Nginx document root.
# * For final testing try to access the App Server 3 link (either hostname or IP)
#   from jump host using curl command. For example curl -Ik https://<app-server-ip>/.

# Login as root
sudo su -

# Install ngsinx
yum install epel-release -y
yum install nginx -y
systemctl start nginx.service
systemctl status nginx.service

# Move SSL certificate and key to /etc/ssl
mv /tmp/nautilus.* /etc/ssl/	

# Create simple html file in nginx root folder
mkdir ip /usr/share/doc/HTML
cat <<'EOT' >> /usr/share/doc/HTML/index.html
Welcome!
EOT

# Configure nginx
cat <<'EOT' > /etc/nginx/conf.d/nautilus.conf
server {

listen   443;

ssl    on;
ssl_certificate    /etc/ssl/nautilus.crt;
ssl_certificate_key    /etc/ssl/nautilus.key;

location / {
    root   /usr/share/nginx/html;
    index  index.html;
  }

}
EOT

# Restart and enable nginx to start in boot
systemctl restart nginx
systemctl enable nginx

# Check your new endpoint via jump host
