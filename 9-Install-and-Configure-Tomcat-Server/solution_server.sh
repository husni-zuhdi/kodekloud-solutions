#!/usr/bin/env bash
#  ______________________________
# |                              |
# |  USE solution_yum.sh SCRIPT  |
# |   TO SOLVE THE KODEKLOUD     |
# |   THIS IS MANUAL SOLUTION    |
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# The Nautilus application development team recently finished the beta version of one
# of their Java-based applications, which they are planning to deploy on one of the app servers
# in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server.
# Based on the requirements mentioned below complete the task:
#  a. Install tomcat server on App Server 2 using yum.
#  b. Configure it to run on port 8085.
#  c. There is a ROOT.war file on Jump host at location /tmp. Deploy it on this tomcat server and make sure
#     the webpage works directly on base URL i.e without specifying any sub-directory anything like this
#     http://URL/ROOT .
# References
# [1] https://linuxhint.com/linux_scp_command/
# [2] https://www.cyberciti.biz/faq/yum-install-wget-redhat-cetos-rhel-7/
# [3] https://unix.stackexchange.com/questions/47909/transfer-files-using-scp-permission-denied
# [4] https://linuxize.com/post/how-to-install-tomcat-9-on-centos-7/
# [5] https://stackoverflow.com/questions/25029707/how-to-deploy-war-file-to-tomcat-using-command-prompt
# [6] https://www.tecmint.com/configure-firewalld-in-centos-7/
# [7] https://hostpresto.com/community/tutorials/install-and-configure-tomcat-8-on-centos-7/
# [8] https://linuxhint.com/replace_string_in_file_bash/
# [9] https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-7-on-centos-7-via-yum


# Login to your server
# Login as root
sudo su -

# Setup Variables
export PORT=5003 # your_running_port
export SERVER_USER=banner # your_server_user

# Install JDK
yum install wget firewalld java-1.8.0-openjdk-devel -y

# Create Tomcat System User
useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download, Extract and Move Tomcat
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
tar -xf apache-tomcat-9.0.65.tar.gz
mv apache-tomcat-9.0.65 /opt/tomcat/apache-tomcat-9.0.65/

# Manage Tomcat Version
ln -s /opt/tomcat/apache-tomcat-9.0.65 /opt/tomcat/latest

# Change directory ownership
chown -R tomcat: /opt/tomcat
cd /opt/tomcat/latest/bin
chmod +x *.sh

# Create systemd unit file
cat <<'EOT' >> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/jre"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

EOT

# Reload daemon of systemd
systemctl daemon-reload

# Adjust firewall
systemctl start firewalld.service
firewall-cmd --zone=public --permanent --add-port=$PORT/tcp
firewall-cmd --reload

# Edit /opt/tomcat/latest/conf/server.xml file
# For port adjustment and restart tomcat
sed -i "s/8080/$PORT/" /opt/tomcat/latest/conf/server.xml

# Add user in tomcat
export TOMCAT_USER=tomcat
export TOMCAT_PASS=tomcat_pa55word
# export TOMCAT_USER_LINE=$(wc -l < /opt/tomcat/latest/conf/tomcat-users.xml)
# export INSERT_LINE=$((TOMCAT_USER_LINE-1))
# sed -i "$INSERT_LINEi    \<role rolename=\"admin-gui\"\/\>\n   \<role rolename=\"manager-gui\"\/\>\n      \<user username=\"$TOMCAT_USER\" password=\"$TOMCAT_PASS\" roles=\"admin-gui,manager-gui\"\/\> $INSERT_LINE" /opt/tomcat/latest/conf/tomcat-users.xml

#Add this line to /opt/tomcat/latest/conf/tomcat-users.xml"
#  <role rolename="admin-gui"/>"
#  <role rolename="manager-gui"/>
#  <user username="tomcat" password="tomcat_pa55word" roles="admin-gui,manager-gui"/>

# Move the war file and deploy 
rm -rf /opt/tomcat/latest/webapps/ROOT
cp /home/$SERVER_USER/ROOT.war /opt/tomcat/latest/webapps/ROOT.war

# Deploy war file
# wget http://$TOMCAT_USER:$TOMCAT_PASS@localhost:$PORT/manager/text/deploy?path=/appname&war=file:/warpath -O - -q

# Start, enable, and check status of  tomcat
# Enable, start, and check status of tomcat service
systemctl enable tomcat
systemctl start tomcat
systemctl status tomcat
