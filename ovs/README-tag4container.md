yum install bridge-utils tunctl 

#add two tag interfaces for virtual machines to use
#创建TAP类型虚拟网卡设备  
```Ruby
tunctl -b -t eth3
tunctl -b -t eth4

ovs-vsctl add-port br0 eth3 -- add-port br0 eth4

ovs-appctl fdb/show br0
ovs-ofctl show br0
ovs-ofctl dump-flows br0
```
---so tired

