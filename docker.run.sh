#!/bin/sh

#set -x

DOCKER_IMAGE=vm-griffin-104.asl.lab.emc.com:5000/skyline-dev:latest
PLATFORM=$(uname -s)
XSOCK=/tmp/.X11-unix
SSH_SESSION_ARGS=
TTY_WRAPPER=

LOCAL_USERDATA=`pwd`/userdata
START_BIN=$@

echo Detected $PLATFORM platform...

if [ "$PLATFORM" = "Linux" ]; then

    if [ ! -d ${LOCAL_USERDATA} ]; then
        echo Creating $LOCAL_USERDATA
        mkdir ${LOCAL_USERDATA}
    fi

    if [ -z "$DISPLAY" ]; then
        echo Setting \$DISPLAY to :0.0
        export DISPLAY=:0.0
    fi

    if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
        # since we're not connect through SSH, setup the DISPLAY and xhost
        export DISPLAY=unix$DISPLAY

        xhost local:root
    else
        # since we're connect through SSH, add extra arguments when starting x11 gui
        # https://dzone.com/articles/docker-x11-client-via-ssh
        SSH_SESSION_ARGS="--net=host -v $HOME/.Xauthority:/home/user/.Xauthority:rw"

    fi
elif [ "$PLATFORM" = "Darwin" ]; then
    if [ ! -d ${LOCAL_USERDATA} ]; then
        echo Creating $LOCAL_USERDATA
        mkdir ${LOCAL_USERDATA}
    fi

    open -a XQuartz

    for i in `ifconfig | grep "inet " | awk '$1=="inet" {print $2}'`; do
        if [ "$i" != "127.0.0.1" ]; then
            xhost + $i
            export DISPLAY=$LOCAL_IP:0.0
            break
        fi
    done

elif [ "$PLATFORM" = "Cygwin" ]; then
    # Reference http://manomarks.github.io/2015/12/03/docker-gui-windows.html

    # This script will setup enable windows to run X11 gui apps by defining DISPLAY
    # and exposing /tmp/.X11-unix.
    #
    # The user must start xserver (ie. cygwin/x, xming, etc.). For cygwin/x, you
    # must start it with "startxwin -- -listen tcp" or else it cannot connect to
    # the display.
    #
    # If eclipse seems to be sluggish, you may need to increase the CPU and MEMORY
    # of the virtualbox vm.

    # NOTE: You must modify boot2docker to include vm-griffin-104 as an insecure
    #       registry.
    #       1. docker-machine ssh
    #       2. vi /var/lib/boot2docker/profile
    #       3. add "--insecure-registry vm-griffin-104.asl.lab.emc.com:5000" in
    #          the EXTRA_ARGS section
    #       4. exit the ssh session
    #       5. docker-machine restart

    # Cygwin requirements:
    #   xinit (for xserver)
    #   xhost
    #   curl
    #   tar

    LOCAL_USERDATA=/c/Users/$USERNAME

    LOCAL_IP=`curl -s http://vm-griffin-104.asl.lab.emc.com/docker/whatismyip.php`

    WINPTY_BIN=./winpty-0.4.0-cygwin-2.5.2-x64/bin/winpty.exe

    if [ ! -f "$WINPTY_BIN" ]; then
        WINPTY_URL=http://vm-griffin-104.asl.lab.emc.com/docker/winpty-0.4.0-cygwin-2.5.2-x64.tar.gz
        echo Cannot find winpty, attempting to get it from $WINPTY_URL
        curl -SL $WINPTY_URL | tar xzv

        if [ ! -f "$WINPTY_BIN" ]; then
            echo Failed to get winpty
            exit 1
        fi
    fi

    TTY_WRAPPER=$WINPTY_BIN

    export DISPLAY=$LOCAL_IP:0.0

    xhost + $LOCAL_IP

    echo "Must start xserver with: startxwin -- -listen tcp &"

    eval $(docker-machine env)

else
    echo "$PLATFORM not supported yet."
    exit 1
fi


DOCKER_CONTAINER_ID=$(docker ps -q)

if [ -z "$DOCKER_CONTAINER_ID" ]; then

    echo Starting a new container...

    $TTY_WRAPPER \
    docker run --rm -it \
        -m 8G \
        -e LOCAL_USER_ID=`id -u $USER` \
        -e DISPLAY=$DISPLAY \
        -v $XSOCK:$XSOCK \
        -v $LOCAL_USERDATA:/home/user \
        --network host \
        $SSH_SESSION_ARGS \
        $DOCKER_IMAGE $START_BIN

else

    echo Attaching to an existing container $DOCKER_CONTAINER_ID...

    $TTY_WRAPPER \
    docker exec -it \
        -u user \
        $DOCKER_CONTAINER_ID bash --login

fi


