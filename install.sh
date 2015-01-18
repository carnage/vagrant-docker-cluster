#!/bin/sh
apt-get update
apt-get install -q -y glusterfs-server docker.io

cp /vagrant/hosts /etc/hosts

gluster peer probe host1
gluster peer probe host2

mkdir -p /exports/gluster
mkdir -p /mnt/gluster

echo "host1:gv0 /mnt/gluster glusterfs defaults,_netdev 0 0" >> /etc/fstab

if [ -n "$1" ]
    then
        gluster volume create gv0 replica 2 transport tcp  host1:/exports/gluster  host2:/exports/gluster force
        gluster volume start gv0
fi

mount /mnt/gluster

echo "Installing nginx"

apt-get -q -y install nginx

echo "nginx config"
cp /vagrant/docker/nginx-docker/nginx.conf /etc/nginx/nginx.conf
usermod -a -G docker www-data

service nginx restart

#cd /vagrant/docker/nginx-docker
#docker.io build -t docker-nginx .
#docker run -d -p 8018:8018 -v /var/run/docker.sock:/var/run/docker.sock docker-nginx
