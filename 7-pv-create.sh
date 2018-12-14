#!/bin/bash

# Creates PVs on master node

SERVER=`hostname`
COUNT=50

sudo mkdir -p /exports
sudo chmod 777 /exports
sudo chown nfsnobody:nfsnobody /exports

oc project default

for i in $(seq 1 $COUNT); do
    PV=$(cat <<EOF
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
    server: $SERVER
    path: /exports/pvm$(printf %04d $i)
EOF
)
    echo "$PV" | oc create -f -
    sudo mkdir -p /exports/pvm$(printf %04d $i)
    sudo chmod 777 /exports/pvm$(printf %04d $i)
    sudo chown nfsnobody:nfsnobody /exports/pvm$(printf %04d $i)
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
    server: $SERVER
    path: /exports/pvo$(printf %04d $i)
EOF
)
    echo "$PVO" | oc create -f -
    sudo mkdir -p /exports/pvo$(printf %04d $i)
    sudo chmod 777 /exports/pvo$(printf %04d $i)
    sudo chown nfsnobody:nfsnobody /exports/pvo$(printf %04d $i)
done
