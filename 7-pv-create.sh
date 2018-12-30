#!/bin/bash

# Creates PVs from master node with NFS
# needs definitions from ./environment.sh
# starts with number STARTWITH and generates COUNT 
# PV's -> one pvo for readOnce and one pvm for readMany
#
# <peter@pflaeging.net>

. ./environment.sh

COUNT=50
STARTWITH=1

ssh root@$NFSSERVER "mkdir -p -m 777 $NFSDIR"
ssh root@$NFSSERVER "chown nfsnobody:nfsnobody $NFSDIR"

oc project default

for i in $(seq $STARTWITH $COUNT); do
    EXPORTMDIR=$NFSDIR/pvm$(printf %04d $i)
    EXPORTODIR=$NFSDIR/pvo$(printf %04d $i)
    PVM=$(cat <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pvm$(printf %04d $i)
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: $NFSSERVER
    path: $EXPORTMDIR
EOF
)
    PVO=$(cat <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pvo$(printf %04d $i)
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: $NFSSERVER
    path: $EXPORTODIR
EOF
)
    echo "$PVM" | oc create -f -
    echo "$PVO" | oc create -f -
    ssh root@$NFSSERVER "mkdir -p -m 777 $EXPORTMDIR $EXPORTODIR"
    ssh root@$NFSSERVER "chown nfsnobody:nfsnobody $EXPORTMDIR $EXPORTODIR"
done
