#!/bin/bash

# generated from http://patorjk.com/software/taag/#p=display&f=Standard&t=Skyline%20Dev

cat<<EOF
  ____  _          _ _              ____             
 / ___|| | ___   _| (_)_ __   ___  |  _ \  _____   __
 \___ \| |/ / | | | | | '_ \ / _ \ | | | |/ _ \ \ / /
  ___) |   <| |_| | | | | | |  __/ | |_| |  __/\ V / 
 |____/|_|\_\\___, |_|_|_| |_|\___| |____/ \___| \_/  
             |___/

Skyline development environment (ubuntu:xenial)
Created on 2016-12-20

Read more about the eCDM software onboarding: https://dpadsw.lss.emc.com/display/eCDM/Software+Onboarding

Installed dev apps/tools
+ jdk-8u91
+ maven-toolchain-3.3
+ eclipse
+ git
+ node.js v6.9.1
  + bower
  + gulp
+ mongodb 3.2.1
+ visual studio code 1.9.0-1486023356
+ golang 1.7.3

Useful scripts in ($INSTALL_HOME/bin)
+ setup-git.sh
+ start-mongodb.sh

PATH=$PATH

New eclipse workspace must run 'mvn mdev:configure-eclipse-workspace'

Note: put custom scripts into ~/bin

EOF


