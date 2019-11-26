#!/bin/bash
#!/bin/sh
# FTP mirroring from local to remote 

apt-get install lftp -y  # for Debian based OS
yum install lftp -y  # for Centos / RHEL
zyper install lftp # for SLES / SuSE

HOST='YourFTPServer Hostname / IP'
USER='myuser1'
PASS='mypassword1'
TARGETFOLDER='/RemoteFolder'
SOURCEFOLDER='/LocalFolder'
lftp ftp://$USER:$PASS@$HOST -e "set ftp:ssl-allow no; mirror -R $SOURCEFOLDER1 $TARGETFOLDER ; quit"
