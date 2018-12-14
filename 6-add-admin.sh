#! /bin/sh
# install okd 3.11

cp /etc/origin/master/admin.kubeconfig ~/.kube/config
oc login -u system:admin
oc adm  policy add-cluster-role-to-user cluster-admin ppadmin
