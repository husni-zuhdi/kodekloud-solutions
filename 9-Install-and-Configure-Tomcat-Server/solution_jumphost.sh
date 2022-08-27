#!/usr/bin/env bash
# The Nautilus application development team recently finished the beta version of one
# of their Java-based applications, which they are planning to deploy on one of the app servers
# in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server.
# Based on the requirements mentioned below complete the task:
#  a. Install tomcat server on App Server 1 using yum.
#  b. Configure it to run on port 8089.
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
export SERVER_HOST=stapp01 # your_server_hostname
export SERVER_USER=tony # your_server_user
export FILE_NAME=ROOT.war
scp /tmp/$FILE_NAME $SERVER_USER@$SERVER_HOST:/home/$SERVER_USER/$FILE_NAME

