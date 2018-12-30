#! /bin/sh

. ./environment.sh

ssh root@$NFSSERVER "mkdir -p -m 777 $NFSDIR/registry-$CLUSTERNAME"
ssh root@$NFSSERVER "mkdir -p -m 777 $NFSDIR/metrics-$CLUSTERNAME"
ssh root@$NFSSERVER "mkdir -p -m 777 $NFSDIR/logging-$CLUSTERNAME"
ssh root@$NFSSERVER "cd $NFSDIR; chown nfsnobody:nfsnobody *-$CLUSTERNAME"

