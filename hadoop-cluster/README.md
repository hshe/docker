#tutorial for centos6:
```Ruby
yum install wget

wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

rpm -ivh epel-release-6-8.noarch.rpm

yum install docker-io

service docker start
 
docker search centos

end ~
```



##other support4build of hadoop-cluster

```Ruby
pipework:
https://github.com/jpetazzo/pipework
pipework,expect，以及iproute，bridge-utils软件。

#time zone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
end
```
