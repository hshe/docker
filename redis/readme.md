##usage of redis container
```Ruby
docker pull redis:alpine

docker run -it redis:alpine

$other connection: persist -volume...
$docker run --name some-redis -d redis redis-server --appendonly yes

docker run -it --link some-redis:redis --rm redis:alpine redis-cli -h redis -p 6379 

end~

```

##create self Dockerfile by reading source code

```Ruby
FROM redis
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]

all of the tutorial in https://hub.docker.com
```



