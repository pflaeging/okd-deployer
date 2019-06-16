# InfraSprint-2

## config access from bastion host

- get sure that oc command is installed, otherwise get it:
  ```curl -LO https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz```
- copy kubeconfig  in place:
  ```mkdir -p ~/.kube; scp masterhost.my.cluster:/etc/origin/master/admin.kubeconfig ~/.kube/config```
- check back with ```oc get all --all-namespaces=true```

## interactive Checklist for cluster

- Check DNS (clustername, wildcard definitions, member names)
- Console walkthrough
- Prometheus check
- Event check
- node check (in Tectonic console)
- cli check
- nfs mount points
- registry-console (https://registry-console.default.clusterdns.alias)

## Sonobuoy tests

Download Sonobuoy:

```sh
curl -LO https://github.com/heptio/sonobuoy/releases/download/v0.14.3/sonobuoy_0.14.3_linux_amd64.tar.gz
```

Start with 

```sh
tar -xvzpf sonobuoy_0.14.3_linux_amd64.tar.gz
./sonobuoy run --wait --skip-preflight
results=$(./sonobuoy retrieve)
 ./sonobuoy e2e $results
 ./sonsbuyoy logs
```

## Update Certs for cluster

- ```oc edit secret router-certs -n default -o yaml``` (rathre complicated, have to encode certs with base64)
- 2nd method:
  - edit inventory (cert config)
  - execute ```ansible-playbook -i inventory openshift-ansible/playbooks/redeploy-certificates.yml```

Complete doc https://docs.openshift.com/container-platform/3.11/install_config/redeploying_certificates.html

## Discuss OpenID config options

