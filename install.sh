#!/bin/sh

apt-get update
apt-get install -q -y glusterfs-server curl

curl -sSL https://experimental.docker.com/ | sh

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

        initctl reload-configuration
fi
