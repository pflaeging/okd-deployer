#! /bin/sh

EXPORT_DIRS="registry metrics logging"
cd /exports
mkdir $EXPORT_DIRS
chown nfsnobody:nfsnobody $EXPORT_DIRS
chmod 777 $EXPORT_DIRS
