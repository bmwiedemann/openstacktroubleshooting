[//]: # (## Focus Areas

* Glance
* Cinder
* Nova
* Neutron
* Keystone)

## Agenda

1. Understanding OpenStack
1. Enabling debug
1. Using standard Linux tools
1. Examining databases
1. Navigating logfiles
1. Discussing further steps

# Understanding OpenStack

## Service Dependencies

![](img/openstackservices.svg)

# Using Debug

## Server side Debug log

/etc/keystone/keystone.conf:

```
[DEFAULT]
debug = true
verbose = true
```

## Client side Debug log

`nova --debug show $ID`

`openstack --debug user show admin`

# Using standard Linux tools

## Network Debugging

`#` **`ping -n -M do -s 1600 $IP`**

`#` **`traceroute $IP`**

`#` **`mtr $IP`**

`>` **`curl -v https://$IP:5000/`**

`>` **`netcat -z $IP 5000 && echo open`**

## Network Debugging \#2

`#` **`tcpdump -epni eth0 port 5000`**

`#` **`tcpdump -s 0 -w dump.pcap -pi eth0 port ! 22`**

## ip netns

`#` **`ip netns list`**
```
snat-83507d7d-9da9-41d2-b17b-ff1e349ac16b
snat-41f2b42d-d365-4ad2-8007-3e116b711e56
qrouter-ecae5b82-b241-40ae-b924-b8e7b82e6aa6
qdhcp-64de8180-d94c-4960-b498-e10d361b42ed
qdhcp-79a51605-d461-4340-a5c8-bda69fcd29ee
qrouter-41f2b42d-d365-4ad2-8007-3e116b711e56
```

`#` **`ip netns exec qrouter-41f2b42d... ip r`**
`10.0.0.0/24 dev qr-39c229b4-fc  proto kernel  scope link  src 10.0.0.1`

## openvswitch

`#` **` ovs-vsctl show`**

`#` **` ovs-ofctl show br-fixed`**

`#` **` ovs-ofctl dump-flows br-fixed`**

## On Compute Node

`#` **` virsh list`**

`#` **` virsh dumpxml $ID`**

## Tracing

`>` **` strace -T sleep 2`**

`>` **` strace -e open ls`**

`>` **` strace -e network netcat localhost 80`**

`#` **` strace -p $(pidofproc neutron-server | cut -f1 -d" ")`**

`>` **` ltrace echo hello`**

# Examining databases

## Mysql / MariaDB

```
~/.my.cnf :
[client]
user     = cinder
password = YOUR_PASSWORD
host     = 192.168.81.29
```

`>` **` mysql cinder`**

`MariaDB [cinder]>` **` show tables;`**

`MariaDB [cinder]>` **` describe volumes;`**

## MariaDB query

`MariaDB [cinder]>` **` SELECT updated_at,id FROM volumes WHERE status='available';`**
```
+---------------------+---------------------------------+
| updated_at          | id                              |
+---------------------+---------------------------------+
| 2018-01-29 09:43:10 | 02f5dcc6-1d5e-450f-22c7e622f158 |
| 2017-12-01 15:02:31 | 065a1f4d-dd58-4a9d-2f8bdcc7818d |
+---------------------+---------------------------------+
2 rows in set (0.00 sec)
```

## Postgresql

`#` **` su - postgres -c 'psql -d cinder'`**

`cinder=#` **` \d`**

`cinder=#` **` \d volumes`**

`#` **` echo "SELECT updated_at,id FROM volumes WHERE status='available';" | 
    su - postgres -c 'psql -d cinder'`**

# Navigating logfiles

## /var/log

`#` **` cd /var/log ; ls */*.log`**

`#` **` tail -f */*.log | grep ERROR`**

# Questions?

# Discussing further steps
