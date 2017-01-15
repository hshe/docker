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




