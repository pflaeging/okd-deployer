# Keycloak as IdP

## Install KeyCloak in Cluster

Use YAMLs from ./openshift-app

## Config KeyCloak

- Add Realm
- Add User Federation
  - LDAP
  - Use 'Active Directory'
  - Test Config
- Add Client OKD-Admin ([Screenshot](screenshots/OKD-Admin-definition.png))
  - Client-Protocol: confidential
  - Fill in valid redirect URIs: https 8443 port of your cluster web-console and ass. services
  - Base URL
  - Mappers ([Screenshot](screenshots/OKD-Admin-preferred_username.png)):
    - preferred_username
      - Mapper-Type: Script Mapper
      - Script: ```exports = user.username + ".admin";```
      - Token Claim Name: preferred_username
      - Claim JSON Type: String
      - All next flags to ON
- Add Client OKD-Developer ([Screenshot](screenshots/OKD-Developer-definition.png))
  - Client-Protocol: confidential
  - Fill in valid redirect URIs: https 8443 port of your cluster web-console and ass. services
  - Base URL
  - Mappers ([Screenshot](screenshots/OKD-Developer-mappers.png)):
    - choose from "Add Builtin": 
      - full name
      - email
      - username

## use keycloak as OpenID provider in OKD (or OpenShift)

In ```/etc/origin/master/master-config.yaml```:

in oauthConfig -> identityProviders: comment out or delete the passage "htpasswd" (or rename it to internal_dont_use)
Add the following sections and edit them:

```yaml
  - name: Developer
    challenge: false
    login: true
    mappingMethod: add
    provider:
      apiVersion: v1
      kind: OpenIDIdentityProvider
      clientID: OKD-Developer
      clientSecret: 8fa29282-872e-45c1-8734-d7d26e65f7c8
#      ca: my-ca-bundle.crt
      urls:
        authorize: https://system-keycloak-keycloak-system-keycloak.lothlorien.pfpk.pro/auth/realms/lothlorien/protocol/openid-connect/auth
        token: https://system-keycloak-keycloak-system-keycloak.lothlorien.pfpk.pro/auth/realms/lothlorien/protocol/openid-connect/token
        userInfo: https://system-keycloak-keycloak-system-keycloak.lothlorien.pfpk.pro/auth/realms/lothlorien/protocol/openid-connect/userinfo
      claims:
        id:
        - preferred_username
        preferredUsername:
        - preferred_username
        name:
        - name
        email:
        - email
  - name: Administrators
    challenge: false
    login: true
    mappingMethod: lookup
    provider:
      apiVersion: v1
      kind: OpenIDIdentityProvider
      clientID: OKD-Admin
      clientSecret: 886c1ff1-c3a9-4a96-81e6-d5b0c4a6f593
#      ca: my-ca-bundle.crt
      urls:
        authorize: https://system-keycloak-keycloak-system-keycloak.lothlorien.pfpk.pro/auth/realms/lothlorien/protocol/openid-connect/auth
        token: https://system-keycloak-keycloak-system-keycloak.lothlorien.pfpk.pro/auth/realms/lothlorien/protocol/openid-connect/token
      claims:
        id:
        - preferred_username
        preferredUsername:
        - preferred_username
        name:
        - preferred_username
```

What you HAVE to change:

- clientSecret -> the second tab in the keycloak client definition holds the secret!
- URL's -> change hostname and realmname
- ca -> if you're TLS chain is not default trusted this should point to a file with your trust-chain in the same dir like the config.

What you CAN change if you want it:

- name -> that's on display while logging in

## Create Admin  Group

On connected command-line
(either on cluster member or bastion host):

```sh
oc adm groups new admin-users
oc create -f add-cluster-admin.yaml
```

## Add users as admins

The mechanism is:

Every user can log on as Developer. The default rights in OKD for the SystemGroup "system:authenticated:oauth"

If you're log on as Administrator your username will be mapped to "myusername.admin" and no user will be automatic created like in Developer. Though we create a user and an identity for the admin user and give him the appropriate group mentioned earlier. 

Here's the example (user mrpowerfull):

```sh
# as cluster-admin
oc create user mrpowerfull.admin
oc create identity Administrators:mrpowerfull.admin
oc create useridentitymapping Administrators:mrpowerfull.admin mrpowerfull.admin
oc adm groups add-users admin-users mrpowerfull.admin
```

Simple shellscript as starting point ```../admin-maker.sh```
