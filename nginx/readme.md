#tutorial
docker pull nginx:1.10.2-alpine

docker run --name my-nginx -d -v /root/docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -p 80:80 nginx:1.10.2-alpine

docker run --name my-nginx -d -v /root/docker/tutorials/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v /root/docker/tutorials/nginx/src:/usr/share/nginx/html:ro -p 80:80 nginx:1.10.2-alpine
