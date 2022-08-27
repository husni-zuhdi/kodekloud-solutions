#!/usr/bin/env bash
# The Nautilus application development team recently finished the beta version of one
# of their Java-based applications, which they are planning to deploy on one of the app servers
# in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server.
# Based on the requirements mentioned below complete the task:
#  a. Install tomcat server on App Server 3 using yum.
#  b. Configure it to run on port 5001.
#  c. There is a ROOT.war file on Jump host at location /tmp. Deploy it on this tomcat server and make sure
#     the webpage works directly on base URL i.e without specifying any sub-directory anything like this
#     http://URL/ROOT .
# References
# [1] https://linuxhint.com/linux_scp_command/
# [2] https://www.cyberciti.biz/faq/yum-install-wget-redhat-cetos-rhel-7/
# [3] https://unix.stackexchange.com/questions/47909/transfer-files-using-scp-permission-denied
# [4] https://linuxize.com/post/how-to-install-tomcat-9-on-centos-7/
# [5] https://stackoverflow.com/questions/25029707/how-to-deploy-war-file-to-tomcat-using-command-prompt

# In jump_host server, run this
# Setup Variables
export SERVER_HOST=stapp03 # your_server_hostname
export SERVER_USER=banner # your_server_user
export FILE_NAME=ROOT.war
scp /tmp/$FILE_NAME $SERVER_USER@$SERVER_HOST:/home/banner/$FILE_NAME

# Login to your server
# Login as root
sudo su -

# Setup Variables
export PORT=5001 # your_running_port

# Install JDK
yum install wget java-1.8.0-openjdk-devel -y

# Create Tomcat System User
useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download, Extract and Move Tomcat
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
tar -xf apache-tomcat-9.0.65.tar.gz
mv apache-tomcat-9.0.65 /opt/tomcat/

# Manage Tomcat Version
# ln -s /opt/tomcat/apache-tomcat-9.0.65 /opt/tomcat/latest

# Change directory ownership
chown -R tomcat: /opt/tomcat
cd /opt/tomcat/bin
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

Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

EOT

# Reload daemon of systemd
systemctl daemon-reload

# Enable, start, and check status of tomcat service
systemctl enable tomcat
systemctl start tomcat
systemctl status tomcat

# Adjust firewall
sudo firewall-cmd --zone=public --permanent --add-port=$PORT/tcp
sudo firewall-cmd --reload
