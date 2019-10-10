#! /bin/sh

. ../environment.sh

for member in $CLUSTERMEMBERS
do
    echo $member 
    echo ssh member update-ca-trust force-enable
    echo scp NGIRootCA01.crt $member:/etc/pki/ca-trust/source/anchors/
    echo ssh member update-ca-trust extract
done