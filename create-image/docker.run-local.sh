#!/bin/bash

xhost local:root

LOCAL_USERDATA=`pwd`/userdata
if [ ! -d ${LOCAL_USERDATA} ]; then
    mkdir ${LOCAL_USERDATA}
fi

docker run --rm -it \
-e LOCAL_USER_ID=`id -u $USER` \
-e LOCAL_P4USER=leongh \
-e DISPLAY=unix$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v $LOCAL_USERDATA:/home/user \
--network host \
vm-griffin-104.asl.lab.emc.com:5000/skyline-dev $@

