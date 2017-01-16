#SWARM

```Ruby

docker swarm init
or
```Ruby
docker swarm init --advertise-addr 192.168.65.12
```
#docker swarm leave
```Ruby
docker swarm leave --force
```

#docker swarm join command
```Ruby
docker swarm join-token worker
docker swarm join-token manager
为了swarm集群的高可用,避免单点故障可以多建立几个manager节点(swarm Ha)

$another node:
docker swarm join –token xxx IP:port

$test
docker service create --name test8 -p 88:80 nginx:1.10-alpine
%auto load balance

```
#running swarm service
```Ruby
将我们原来我们使用的docker run命令替换成docker service create就行了，命令后面的格式和选项全都一样。
docker service create =docker run 
(如果出错，swarm集群会不断帮你重试启动容器,直到成功为止)

watch docker service ps [Name]
accepted 任务已经被分配到某一个节点执行
preparing 准备资源, 现在来说一般是从网络拉取image
running 副本运行成功
shutdown 呃, 报错,被停止了…
        当一个任务被终止stoped or killed.., 任务不能被重启, 但是一个替代的任务会被创建.
docker service rm <Service ID or Name> 命令删除服
```

#check service status
```Ruby
docker service ps [serviceName]
docker service ls
docker node ls
docker swarm 
docker node rm [ID]
```
#容器的通信问题
```Ruby
1.单节点场景中，我们应用所有的容器都跑在一台主机上, 所以容器之间的网络是内部互通的。

在docker 1.12中已经内置了这个存储并且集成了overlay networks的支持
在docker 1.12以前, swarm集群需要一个额外的key-value存储(consul, etcd etc)来同步网络配置, 保证所有容器在同一个网段中。

步骤：

创建一个overlay network
docker network create --driver overlay test  //创建一个名为test的overlay network
docker network ls //查看network列表
ps:local:表示的是本机网络,swarm表示的是整个集群生效的。
ps:其它node节点也已经创建了这个网络。


#在配置的网络上运行容器
直接使用--network <network name>参数, 在指定网络上创建service.
docker service create --network test --name nginx -p 80:80 nginx(Nginx的这个版本启动很慢）
docker service create --name test8 -p 88:80 nginx:1.10-alpine
docker service create --network test --name test8 -p 88:80 nginx:1.10-alpine
$这时可以利用监控，看它到哪一个步骤了：
docker service ps nginx 

启动完成后。就可以从所有的节点访问到了。
<<事实上, 你可以通过访问swarm集群中的所有节点(192.168.65.12 - 192.168.65.13)的80端口来访问到我们的webui.>>

```
#扩展（Scaling）应用
```Ruby
1.docker service scale worker=10
2.通过修改服务的属性来实现
 docker service inspect test7   //查询service属性
docker service update test7 --replicas 5  //更新test7服务属性

docker service create --network test --name test8 -p 88:80 nginx:1.10-alpine
创建容器时，如有下面的参数，global模式的service, 就是在swarm集群的每个节点创建一个容器副本, 所以如果你想让一个service分布在集群的每个节点上
 --mode global 

```
###扩展
```Ruby

找程序瓶颈
             # docker service create --network test --name debug --mode global alpine sleep 1000000000
                启动一个临时容器, debug使用alpine镜像, 连接到test网络中.
--mode globle 是啥意思呢?global模式的service, 就是在swarm集群的每个节点创建一个容器副本, 所以如果你想让一个service分布在集群的每个节点上，可以使用这个模式.
sleep 1000000000是为啥呢？因为懒, 想保持这个容器, 方便我们debug.
       
          随便进入某个节点中的debug容器，安装性能测试工具：curl,ab和drill  -------#apk add --update curl apache2-utils drill
```

#压力测试
test.md
