# InfraSprint 1 --> Setup

## Install on first

```sh
yum -y update
yum -y epel-release
yum -y install git ansible docker docker-compose bash-completion pyOpenSSL

systemctl enable docker --now

cd /opt
mkdir -p docker
```

copy your certs to ```/opt/docker/certs```
```sh
chcon -Rt svirt_sandbox_file_t /opt/certs/
```

### get harbor

```sh
curl -O https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-offline-installer-v1.8.0.tgz

tar -xvzf harbor-offline-installer-v1.8.0.tgz
cd harbor
```

copy harbor/harbor.yml to /opt/docker/harbor and check it!


Comment out the ```exit 1``` after the line ```error "Need to upgrade docker package to 17.06.0+."```

Comment out the OPTION "--selinux-enabled" in ```/etc/sysconfig/docker```

Then

```sh
./install.sh --with-notary --with-clair --with-chartmuseum
```

After this you can reenable the "--selinux-enabled" again (don't forget ```systemctl restart docker```)

Login after this with "admin" and the password from the harbor.yml file!

Create public projects: 

- coreos
- openshift
- grafana
- cockpit

# OKD install

```sh
yum install -y centos-release-openshift-origin311 yum-utils java-1.8.0-openjdk-headless "@Development Tools"
mkdir /opt/centos-origin-rpms
cd /opt/centos-origin-rpms
reposync --repoid=centos-openshift-origin311
```

```sh
yum remove ansible
curl -O https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.7.9-1.el7.ans.noarch.rpm
rpm -i ansible-2.7.9-1.el7.ans.noarch.rpm
rm ansible-2.7.9-1.el7.ans.noarch.rpm
```

```sh
mv inventory inventory-online
cp inventory-airgap inventory
```

## Customize config

in inventory:

- hostnames
- nodes
- masters
- etcd hosts
- nfs config
- ip ranges
- certificate paths

Double check if all images are in local registry and add the following to the variable 
```openshift_disable_check```: ```docker_image_availability```.
(This is due to problems with skopeo and some registry configs. You can try to pull the images on one of the machines with ```docker pull```).

Insert and set the following variables appropriate in ```[OSEv3:vars]```

```init
# Images for airgap
## Where do we get the images from:
oreg_url=reg.pflaeging.net/openshift/origin-${component}:${version}
openshift_examples_modify_imagestreams=true
openshift_cockpit_deployer_image='reg.pflaeging.net/cockpit/kubernetes:latest'
openshift_web_console_prefix='reg.pflaeging.net/openshift/origin-'
openshift_service_catalog_image_prefix='reg.pflaeging.net/openshift/origin-'
ansible_service_broker_image_prefix='reg.pflaeging.net/openshift/origin-'
template_service_broker_prefix='reg.pflaeging.net/openshift/origin-'
```

in environment.sh:

- clustername
- nfs config like in inventory

On all clients:

```sh
yum install -y java-1.8.0-openjdk-headless docker
```

## Patch docker config on all systems:

### /etc/sysconfig/docker-network

```
DOCKER_NETWORK_OPTIONS='--mtu=1450 --bip=192.168.25.1/24'
```

### /etc/docker/daemon.json

```json
{
  "insecure-registries" : [ "bastion-host.my.domain" ]
}
```


## preload the harbor registry

- execute the python script in infrasprint-1/.
- copy openshift-ansible-patcher.sh to okd-deployer main and execute it
- copy pull+push.sh to a gateway host and execute it

## install

Try to ssh to cluster members as root to root.

Now try the 7 step installer from one directory up!
