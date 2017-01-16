docker run \
--n=false \
--lxc-conf="lxc.network.type = veth" \
--lxc-conf="lxc.network.ipv4 = 192.168.65.200/24" \
--lxc-conf="lxc.network.ipv4.gateway = 192.168.65.2" \
--lxc-conf="lxc.network.link = dr0" \
--lxc-conf="lxc.network.name = eth0" \
--lxc-conf="lxc.network.flags = up" \
--i -t centos:latest /bin/bash
