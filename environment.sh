#! /bin/sh

NFSSERVER=okd-manage.novomatic.com
NFSDIR=/nfs

CLUSTERNAME=okd-poc.novomatic.com

CLUSTERMEMBERS="okd-cluster-nd1.novomatic.com okd-cluster-nd2.novomatic.com okd-cluster-nd3.novomatic.com okd-cluster-nd4.novomatic.com"

export NFSSERVER NFSDIR CLUSTERNAME  CLUSTERMEMBERS
