#SWARM

```Ruby

docker swarm init

$another node:
docker swarm join –token xxx IP:port

$test
docker service create --name test8 -p 88:80 nginx:1.10-alpine
%auto load balance

```
