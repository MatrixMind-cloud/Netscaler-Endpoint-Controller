#!/bin/bash

export NS_NAME=Netscaler

if [ ! "$(docker ps -q -f name=$NS_NAME)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$NS_NAME)" ]; then
        echo "cleanup of netscaler container because it is inactive"
        docker rm $NS_NAME
    fi
    echo "starting netscaler container"    
    docker run --name $NS_NAME -e EULA=yes -dt -p 22 -p 80 -p 161/udp --ulimit core=-1 --cap-add=NET_ADMIN store/citrix/netscalercpx:12.0-56.20
fi 

if ! command -v kopf &> /dev/null
then
    echo "kopf could not be found locally ... installing it now with pip"
    pip install kopf
fi

kopf run src/handler.py --verbose