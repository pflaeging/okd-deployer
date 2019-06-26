# Keycloak as IdP

## Install KeyCloak in Cluster

Use YAMLs from ./openshift-app

## Config KeyCloak

- Add Realm
- Add Use Federation
    - LDAP
    - Use 'Active Directory'
    - Test Config
- Add Client OKD-Admin
    - 
- Add Client OKD-Developer
- Add Groups
    - OKD-Admin-Group
    - OKD-Developer-Group


## Create Admin  Group

```sh
oc adm groups new admin-users
oc create -f add-cluster-admin.yaml
```

## Add users to admin groups

Periodically or on demand start 

```sh
oc adm groups add-users admin-users `oc get users | cut -d " " -f 1 | grep '\.admin$'`
```
