#!/bin/bash

#if [ $# -eq 0 ]; then
#    echo "$0 <image_id>"
#    exit
#fi
#
#IMAGE_ID=$@

# for debugging...
set -x

docker push vm-griffin-104.asl.lab.emc.com:5000/skyline-dev
