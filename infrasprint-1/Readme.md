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

# OKD install

```sh
yum install -y centos-release-openshift-origin311 yum-utils java-1.8.0-openjdk-headless
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

Try to ssh to cluster members as root to root.

Now try the 7 step installer from one directory up!

