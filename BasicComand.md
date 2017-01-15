#basic command for docker

before install docker 
```Ruby
yum list docker --showduplicates
yum install docker 

systemctl start docker
systemctl enable docker
#centos 6 
service docker start
chkconfig docker on

end ~

```
#pull the images and run 
```Ruby
docker search centos
docker pull centos

docker run -i -t centos /bin/bash
$check the running
docker ps [-a/-l/-n num]

docker start containerID
doker attach containerID(which container is starting)

docker run -name daemon_name -d centos /bin/bash -c "whiletrue; do echo  hello world; sleep 1; done"
end ~
```


#watch docker's Thread
docker top containerID

#docker Command2
```Ruby
##Running inside the Docker container
docker exec -d daemon_hshe touch /etc/hshe_file
docker exec -t -i daemon_hshe /bin/bash

#demo
docker exec -d daemon_hshe touch /etc/hshe_file
docker attach daemon_hshe
ll /etc/hshe_file 
end~

docker stop  containerID
docker kill containerID

$watch the detail of running container
docker inspect daemon_hshe

$remove docker container
docker rm containerID
docker rm `docker ps -a -q`
(docker ps -a --> all containers) (-q list all containerID)

$container:export and import to tar package
export:
docker export containerID > my_hshe.tar
import:
cat my_hshe.tar | docker import - imageName:tag
cat my_redis.tar | docker import - my_redis:1.0
docker images


$images:save and load
save:
docker save imageID > my_image.tar
load:
docker load < my_image.tar

-->example:
docker save my_redis > my_redis2.tar
docker rmi my_redis
docker images
docker load < my_redis2.tar 
docker images

```
#deep learning docker 
```Ruby
$build docker image by container (docker commit)
:command
docker commit containerID hshe-jdk:1.0
docker commit -m="describe" --author="hshe"  containerID hshe-jdk:2.0
docker inspect hshe-jdk:2.0

Dockerfile:
FROM centos
..... other demo is more details

#check image's building step and level
docker history [IMAGE ID]


```
#others:
```Ruby
CMD(指定一个容器运行时要执行的命令)
docker run -i -t crxy/cenos-tomcat /bin/bash
等于在Dockerfile中添加 CMD ["/bin/ps"]
注意：使用docker run 命令可以覆盖CMD指令。
ENTRYPOINT(与CMD类似，但是ENTRYPOINT指定的命令不会被docker run指定的命令覆盖，它会把docker run命令行中指定的参数传递给ENTRYPOINT指令中指定的命令当作参数。)
ENTRYPOINT ["/bin/ps"]
docker run -t -i crxy/centos  -l
ENTRYPOINT 还可以和CMD组合一块来用，可以实现，当用户不指定参数的时候使用默认的参数执行，如果用户指定的话就使用用户提供的参数
ENTRYPOINT ["/bin/ps"]
CMD ["-h"]
注意：如果确实要覆盖默认的参数的话，可以在docker run中指定--entrypoint进行覆盖
WORKDIR
WORKDIR /etc
RUN touch a.txt
WORKDIR /usr/local
RUN touch b.txt
注意：可以在docker run命令中使用-w覆盖工作目录，但是不会影响之前在工作目录中执行的命令
ADD	含解压
COPY 直接复制到docker


删除镜像
docker rmi 用户ID/镜像名
或者docker rmi `docker images -a -q`
删除所有未打标签的镜像
 docker rmi -f $(docker images --filter 'dangling=true')


```
```Ruby
do something...
```



