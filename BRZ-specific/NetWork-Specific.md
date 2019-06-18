# Network specific settings for BRZ

## harbor & bastion host

- the standard bridge network for the bastion host should be 192.168.25.1/25 (/etc/sysconfig/docker-network)
- Create a network ```harbor0```with 192.168.25.128/25 
  (```docker network create harbor0 --ip-range 192.168.25.128/25 --subnet 192.168.25.128/25 --gateway 192.168.25.254```)
- edit docker-compose.yml in harbor so that:
  - every service joins the network harbor0
  - declare harbor0 as external
  - delete all other networks

## NFS problems

Setting iptables to allow connects from all nodes and masters to NFS Server (the bastion host in our testcase)
(assuming all okd nodes and masters are in 172.17.56.0/24)

On NFS server:
```sh
iptables -A INPUT -s 172.17.56.0/24 -j ACCEPT # allow all inbound
iptables -A OUTPUT -s 172.17.56.0/24 -j ACCEPT # allow all outbound
iptables-save > /etc/sysconfig/iptables # save iptables for later reload by system
```

Either all hosts should have enabled IPA or none! Otherwise NFS v4 will have problems due to different domains.
