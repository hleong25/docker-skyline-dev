#!/bin/bash

DATADB=~/mongodb

if [ ! -d $DATADB ]; then
    mkdir $DATADB
fi

mongod --dbpath $DATADB &
