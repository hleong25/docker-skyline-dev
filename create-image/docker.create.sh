#!/bin/bash

#docker build --no-cache -t vm-griffin-104.asl.lab.emc.com:5000/skyline-dev .
docker build --network host -t vm-griffin-104.asl.lab.emc.com:5000/skyline-dev .
