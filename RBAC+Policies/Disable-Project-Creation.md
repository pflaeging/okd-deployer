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

ClusterRoleBinding self-provisioners: ```oc get clusterrolebinding self-provisioners -o yaml```

```yaml
apiVersion: authorization.openshift.io/v1
groupNames:
- system:authenticated:oauth
kind: ClusterRoleBinding
metadata:
  annotations:
    openshift.io/reconcile-protect: "false"
  creationTimestamp: 2019-06-14T21:31:01Z
  name: self-provisioners
  resourceVersion: "250"
  selfLink: /apis/authorization.openshift.io/v1/clusterrolebindings/self-provisioners
  uid: b4c36a52-8eeb-11e9-ae0e-e66952204b37
roleRef:
  name: self-provisioner
subjects:
- kind: SystemGroup
  name: system:authenticated:oauth
userNames: null
```

There's no function to show system groups :-(

## Disable self-provisioning 

 Set Autoupdate to false:

 ```oc patch clusterrolebinding self-provisioners -p '{ "metadata": { "annotations": { "rbac.authorization.kubernetes.io/autoupdate": "false" } } }'```

Remove member groups:

```oc patch clusterrolebinding self-provisioners -p '{"subjects": null}'```

## Optional 

On the masters ```/etc/origin/master/master-config.yaml```:

In the part "projectConfig" overwrite "ProjectRequestMessage" with your own text!

## Additional files

For reference: self-provisioners-clusterrolebinding-default.yaml in this directory!