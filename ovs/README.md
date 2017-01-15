#before intall
```Ruby
wget http://openvswitch.org/releases/openvswitch-2.6.1.tar.gz
```
```Ruby
yum install gcc make python-devel openssl-devel kernel-devel graphviz \
    kernel-debug-devel autoconf automake rpm-build redhat-rpm-config \
    libtool checkpolicy selinux-policy-devel
```

```Ruby
$ ./boot.sh
$ ./configure
$ make dist


```
#build .
```Ruby
yum -y install openssl-devel wget kernel-devel
wget http://openvswitch.org/releases/openvswitch-2.3.1.tar.gz
tar xfz openvswitch-2.3.1.tar.gz
mkdir -p ~/rpmbuild/SOURCES
sed 's/openvswitch-kmod, //g' openvswitch-2.3.1/rhel/openvswitch.spec > openvswitch-2.3.1/rhel/openvswitch_no_kmod.spec
cp openvswitch-2.3.1.tar.gz ~/rpmbuild/SOURCES
rpmbuild -bb ~/openvswitch-2.3.1/rhel/openvswitch_no_kmod.spec

pwd:
/root/rpmbuild/RPMS/x86_64

yum localinstall openvswitch-2.3.1-1.x86_64.rpm 
service openvswitch start
```

#another ways no build ....
```Ruby
download from other users

http://rpm.pbone.net/index.php3/stat/4/idpl/31446019/dir/centos_6/com/openvswitch-2.4.0-1.el7.x86_64.rpm.html
```

#usage of openvswitch
```Ruby
*查看模块
lsmod |grep openvs
当前没有建立虚拟交换机
ovs-vsctl show
创建一个网桥
ovs-vsctl add-br br0 
查看
ifconfig -a
ip link

启动网桥
ifconfig br0 up

```
```Ruby

[root@hse network-scripts]# vi ifcfg-br0 
DEVICE=br0
BOOTPROTO=static
BROADCAST=192.168.65.255
ONBOOT=yes
NM_CONTROLLED=no
IPADDR=192.168.65.200
NETMASK=255.255.255.0
GATEWAY=192.168.65.2
DNS1=192.168.65.2

[root@hse network-scripts]# vi ifcfg-eth0 
DEVICE=eth0
HWADDR=00:0C:29:16:0F:11
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
BRIDGE="br0"


ovs-vsctl add-port br0 eth0;service network restart
```
other command
```Ruby
ovs-vsctl show

ovs-vsctl add-br br1
ifconfig br1 up
ovs-vsctl show
```


