#!/bin/bash

docker run -e STORAGE_PATH=/registry -v /mnt/gluster/registry:/registry -p 5000:5000 registry
