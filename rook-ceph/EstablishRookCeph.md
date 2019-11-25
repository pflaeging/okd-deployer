# Establish rook-ceph on Openshift / OKD 3.11

## configure nodes with storage (osd's)

Give your nodes a label and create or mount a `/data` directory.

```shell
oc label node my-nodename pflaeging.net/rook-ceph-storage=true
```

## deploy ceph storage inside OKD

Now you can enable the services:

```shell
oc create -f common.yaml
oc create -f operator-openshift.yaml
oc create -f cluster.yaml
oc create -f storageclasses-flexvolume.yaml
oc create -f toolbox.yaml
oc create -f dashboard-route.yaml
```

You've got access to:
<https://rook-ceph-mgr-dashboard-rook-ceph.MYFAMOUSCLUSTERNAME/>

- User: admin
- Password: `oc get secret rook-ceph-dashboard-password -o yaml | grep password: | cut -d " " -f 4 | base64 -d -i -`


And you can go into the toolbox:

```shell
oc rsh `oc get pod -l app=rook-ceph-tools -o name`
```

## Test the StorageClass

Change to a "test" project with `oc`.

```shell
oc create -f test-registry.yaml
```

This deploys a docker registry for you and makes a PVC!

You can check with

```shell
oc rsh `oc get pod -l k8s-app=kube-registry -o name`
```

Here you have a mounted dir `/var/lib/registry` on `/dev/rbd0`.

## Access your volume from rook-ceph-tools

`rbd list -p replicapool` shows your images (PV's).
They are formatted as xfs when they are in use. So you have to create a device with `rbd map IMAGENAME -p replicapool`. After this you can mount it with: `mount -t xfs /dev/rbd.... /mnt`.

If there's no filesystem on the image you can create one with `mkdir.xfs /dev/rbd....`.
