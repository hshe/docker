#!/bin/bash

# 单个节点镜像的名称
IMAGE=hadoop-cluster
echo "The hostname of namenode will be master"
echo "How many datanode would you want? Please enter:"
# 读入Datanode的个数
read num

echo "the hostname of datanode will be:"
if [ -f "slaves" ]; then
  rm -f slaves
fi

# namenode 主机名直接配置为master,并将其加入到hadoop配置文件中的slaves文件，以及容器的配置文件hosts。
# （此时这两文件在本地，配置完成后会上传到容器中）
if [ -f "hosts" ]; then
  rm -f hosts
  echo "127.0.0.1    localhost" >> hosts
  echo "192.168.1.10 master" >> hosts
fi

# 配置hadoop中的slaves文件，说明有哪些是datanode
# 其中每一个datanode容器的主机名都为slave再接上一个数字，主机的ip所在的网络为： 192.168.1.0/24
for count in $(seq $num)
do
  echo "slave$count"
  echo "slave$count" >> slaves
  echo 192.168.1.1$count" "slave$count >> hosts
done

# 因为要重新建立镜像，所以停止以前的容器所用镜像名为hadoop-cluster的容器，并将这些容器删除
echo "stop and remove the relevant containers.."
names=(`docker ps -a | grep $IMAGE | awk '{print $1}'`)
for name in ${names[*]}
do
  echo $name
  docker stop $name
  docker rm $name
done

# 删除旧版的镜像名为hadoop-cluster镜像（如果存在）
cluster=`docker images | grep $IMAGE`
if [ -z "$cluster" ]; then
  echo "the $IMAGE image is not existed!"
else
  echo "removing the $IMAGE..."
  docker rmi $IMAGE
fi

# 通过上述的Dockerfile构建新的镜像名为hadoop-cluster的镜像
echo "build the $IMAGE image..."
docker build -t "$IMAGE" .

# 容器和主机可能会可能会与主机共享文件，先建立共享的文件夹（不同的容器的主机名对应不同的文件夹）
echo "creating the namenode master..."
if [ ! -d "/data/share" ]; then 
  mkdir -p /data/share
fi
if [ ! -d "/data/share/master" ]; then
  mkdir /data/share/master
fi

# 后边的配置会用到br0虚拟网桥，如果存在就先将其删除
ip link set br0 down
ip link delete br0
# 删除主机中的~/.ssh/known_hosts文件，不然可能会报这样的错误： IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!。。。
rm -f  ~/.ssh/known_hosts
# 建立namenode容器，其主机名为master
docker run -itd -p 50070:50070 -p 8088:8088 --name=master --hostname=master --privileged=true --net=none -v /data/share/master:/opt/share  $IMAGE
# 通过pipework为容器设置固定IP（重新开启容器将不存在）
pipework br0 master 192.168.1.10/24@192.168.1.1

# 创建并配置datanode容器
echo "creating the datanodes.."
for count1 in $(seq $num) 
do
  nodename=slave$count1
  addr=192.168.1.1$count1
# 建立共享目录
  if [ ! -d "/data/share/$nodename" ]; then
    mkdir /data/share/$nodename
  fi
  docker run -itd --name=$nodename --hostname=$nodename --privileged=true --net=none -v /data/share/$nodename:/opt/share  $IMAGE
# 设置固定IP  
  echo $nodename
  echo $addr
  pipework br0 $nodename $addr/24@192.168.1.1
done

# 为虚拟网桥br0添加IP，同时会增加通往192.168.1.0/24子网的路由。
ip addr add 192.168.1.1/24 broadcast +1 dev br0

# 先删除文件夹下的authorized_keys文件
if [ -f "authorized_keys" ]; then
  rm -f authorized_keys
fi
# 先将每个主机中的id_rsa.pub中的内容先下载到到此文件夹下，然后将其中的内容加入到的authorized_keys文件中
# 然后在将authorized_keys放置到每个容器的 ~/.ssh/中，这样每个容器之间就可以完成免密码登陆
# 脚本download.sh和upload.sh中使用expect命令，来完成登陆过程中不用输入密码，在脚本中事先指定密码。

for ((i=0; i<=$num; i++))
do
  addr=192.168.1.1$i
  ./download.sh $addr ~/.ssh/id_rsa.pub rsa_tmp
  cat rsa_tmp >> authorized_keys
  rm -f rsa_tmp
done
# 将hosts以及authorized_keys文件复制到每个容器的指定位置中去
for ((i=0; i<=$num; i++))
do
  addr=192.168.1.1$i
  ./upload.sh $addr authorized_keys  ~/.ssh/
  ./upload.sh $addr hosts  /etc/hosts
done
