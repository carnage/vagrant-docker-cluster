#!/bin/sh

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -q -y glusterfs-server lxc-docker

cp /vagrant/hosts /etc/hosts

mkdir -p /exports/gluster
mkdir -p /mnt/gluster

echo "host1:gv0 /mnt/gluster glusterfs defaults,_netdev 0 0" >> /etc/fstab

if [ -n "$1" ]
    then
        HOSTS=$(wc -l < /etc/hosts)

        if [ $HOSTS = "3" ]; then
            REPLICA=3
        else
            REPLICA=2
        fi

        BRICKS='';
        while read host; do
            NAME=$(echo $host | cut -d ' ' -f 2);
            gluster peer probe $NAME;
            BRICKS="$BRICKS $NAME:/exports/gluster";
        done < /etc/hosts;


        gluster volume create gv0 replica $REPLICA transport tcp $BRICKS force
        gluster volume start gv0
fi

cp /vagrant/docker-defaults /etc/default/docker.io
service docker restart
