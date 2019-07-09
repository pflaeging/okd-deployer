# Disable project creation for ordinary users

## Components

- ClusterRole: self-provisioner
- ClusterRoleBinding: self-provisioners
- SystemGroup: system:authenticated:oauth

## Contents of components

ClusterRole self-provisioner: ```oc get clusterrole self-provisioner -o yaml```

```yaml
apiVersion: authorization.openshift.io/v1
kind: ClusterRole
metadata:
  annotations:
    authorization.openshift.io/system-only: "true"
    openshift.io/description: A user that can request projects.
    openshift.io/reconcile-protect: "false"
  creationTimestamp: 2019-06-14T21:31:00Z
  name: self-provisioner
  resourceVersion: "114"
  selfLink: /apis/authorization.openshift.io/v1/clusterroles/self-provisioner
  uid: b48d5153-8eeb-11e9-ae0e-e66952204b37
rules:
- apiGroups:
  - ""
  - project.openshift.io
  attributeRestrictions: null
  resources:
  - projectrequests
  verbs:
  - create
```

ClusterRoleBinding self-provisioners: ```oc get clusterrolebinding.rbac self-provisioners -o yaml```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  creationTimestamp: 2018-12-29T16:16:51Z
  name: self-provisioners
  resourceVersion: "27691546"
  selfLink: /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/self-provisioners
  uid: 26a93980-0b85-11e9-a275-5a9c3c3f87d7
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: self-provisioner
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: system:authenticated:oauth
```

There's no function to show system groups :-(

## Disable self-provisioning

 Set Autoupdate to false:

 ```oc annotate clusterrolebinding.rbac self-provisioners "rbac.authorization.kubernetes.io/autoupdate=false" --overwrite```

Remove member groups:

```oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth```

## Optional 

On the masters ```/etc/origin/master/master-config.yaml```:

In the part "projectConfig" overwrite "ProjectRequestMessage" with your own text!

## Additional files

For reference: [self-provisioners-clusterrolebinding-default.yaml](./self-provisioners-clusterrolebinding-default.yaml) in this directory!
