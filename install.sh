#!/bin/sh

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -q -y glusterfs-server lxc-docker

cp /vagrant/docker-defaults /etc/default/docker
service docker restart

cp /vagrant/hosts /etc/hosts

mkdir -p /exports/gluster
mkdir -p /mnt/gluster

echo "host1:gv0 /mnt/gluster glusterfs defaults,_netdev 0 0" >> /etc/fstab

if [ -n "$1" ]
    then
        HOSTS=$(wc -l < /etc/hosts)
        HIGH_IP=$((HOSTS+1))

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

        wget https://github.com/docker/swarm-library-image/blob/3c2dd0f73b7351744af64efb38e4fa5a015cc114/swarm?raw=true -O /usr/bin/swarm
        chmod +x /usr/bin/swarm

        cp /vagrant/swarm.conf /etc/init/swarm.conf
        echo "SWARM_OPTS=\"-H 0.0.0.0:2735 nodes://192.168.10.[2:$HIGH_IP]:8018\"" > /etc/default/swarm
        initctl reload-configuration
        service swarm start
fi
