#!/bin/bash
# <peter@pflaeging.net>

NFSSERVER=nfs1.pfpk.pro
NFSDIR=/exports

DIRECTORY=$1

ssh root@$NFSSERVER "mkdir -p -v -m 777 $NFSDIR/$DIRECTORY"
ssh root@$NFSSERVER "chown nfsnobody:nfsnobody $NFSDIR $NFSDIR/$DIRECTORY"