#!/usr/bin/env bash
# There is a critical issue going on with the Nautilus application in Stratos DC.
# The production support team identified that the application is unable to connect
# to the database. After digging into the issue, the team found that mariadb service
# is down on the database server.
# Look into the issue and fix the same.

# Log as root
sudo su -

# Check the mariadb service
systemctl | grep maria
yum list | grep maria

# Try to start mariadb service
systemctl start mariadb.service
###################
## Got this message
###################
# Job for mariadb.service failed because the control process exited with error code.
# See "systemctl status mariadb.service" and "journalctl -xe" for details.

# Check mariadb status
systemctl status mariadb.service
###################
## Got this message
###################
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com mariadb-prepare-db-dir[645]: Database MariaDB is not initialized, but the directory /var/lib/mys...done.
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: Child 645 belongs to mariadb.service
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service: control process exited, code=exited status=1
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service got final SIGCHLD for state start-pre
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service changed start-pre -> failed
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: Job mariadb.service/start finished, result=failed
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: Failed to start MariaDB database server.
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: Unit mariadb.service entered failed state.
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service failed.
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service: cgroup is empty

# Look more into the log
journalctl -u mariadb.service
###################
## Got this message
###################
# Sep 10 22:09:22 stdb01.stratos.xfusioncorp.com mariadb-prepare-db-dir[645]: Database MariaDB is not initialized,
# but the directory |HINT ==>| /var/lib/mysql |<== HINT| is not empty, so initialization cannot be done.

# Take a look into /var/lib
ls -la /var/lib
##################
## Got this
##################
# drwxr-xr-x 1 root  root  4096 Mar 27  2021 alternatives
# drwxr-xr-x 1 root  root  4096 Mar 14  2019 dbus
# drwxr-xr-x 1 root  root  4096 Apr 11  2018 games
# drwxr-xr-x 1 root  root  4096 Nov  2  2018 initramfs
# drwx------ 1 root  root  4096 Aug  1  2019 machines
# drwxr-xr-x 1 root  root  4096 Apr 11  2018 misc
#####################################################
# drwxr-xr-x 5 mysql mysql 4096 Sep 10 22:41 mysqld #
#####################################################
# drwxr-xr-x 1 root  root  4096 Sep 10 22:07 rpm
# drwxr-xr-x 1 root  root  4096 Apr 11  2018 rpm-state
# drwxr-xr-x 1 root  root  4096 Oct 15  2019 stateless
# drwxr-xr-x 1 root  root  4096 Aug  1  2019 systemd
# drwxr-xr-x 1 root  root  4096 Mar 27  2021 yum

# Make sure the folder ownership is right and move the folder name
chown -R mysql:mysql /var/lib/mysql
mv mysqld/ mysql/

# Start the service
systemctl start mariadb
