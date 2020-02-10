#! /bin/sh

. ../environment.sh

for member in $CLUSTERMEMBERS
do
    echo $member 
    ssh $member update-ca-trust force-enable
    scp  MyRouteCaComesHere.crt $member:/etc/pki/ca-trust/source/anchors/
    ssh $member update-ca-trust extract
done
