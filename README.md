# vagrant docker cluster

This repository contains a set of scripts for creating a cluster of docker hosts using vagrant. It is intended for developers to be able to easilly test their inter-container linking and ensure a smooth transition to a production environment.

# What the hosts's provide

Each host is running ubuntu 14.04.

Docker is automatically installed on each host and setup to listen on ANY ip and port 8018 this is to make connecting to the docker deamons externally much easier, however configured in this way there is NO security around the docker api endpoint. For dev this is no major issue but DO NOT use these scripts as an example of how to configure docker in production.

All the hosts also have a shared networked filesystem provided by glusterfs, this is mounted at /mnt/gluster and is a good place to put your containers volumes to enable easy migration of containers between cluster hosts. Be careful when sharing a volume between multiple containers, some systems may not work correctly if you do (eg mysql) 

# How to use

The repository contains a hosts file which follows the standard /etc/hosts format and is used to define the hosts you want to spin up. For the gluster fs filesystem to work correctly, the total number of hosts must be either an even number or 3. Every host in the file must be followed by a new line (including the last host).

Once you have edited the hosts file to define the number of hosts you want type vagrant up as you would usually for vagrant. This will spin up the cluster. Once everythign has installed correctly you will need to restart each of the hosts to mount the filesystem (vagrant halt, vagrant up) you may need to do this one host at a time.

To ssh into any of the hosts you will need to provide vagrant with the host you want to use eg vagrant ssh host1
