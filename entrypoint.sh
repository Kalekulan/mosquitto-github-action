#!/bin/sh

VERSION=$1
PORTS=$2
ANONYMOUS=$3
CERTIFICATES=$4
CONFIG_DIR=$5
PASSWORD_FILE=$6
CONTAINERNAME=$7

echo "Certificates: $CERTIFICATES"
echo "Config: $CONFIG"

docker_run="docker run --detach --name $CONTAINERNAME"

for i in $(echo $PORTS | tr " " "\n")
do
  docker_run="$docker_run --publish $i"
done


if [ -n "$CERTIFICATES" ]; then
  docker_run="$docker_run --volume $CERTIFICATES:/mosquitto-certs:ro"
fi

if [ -n "$CONFIG_DIR" ]; then
  docker_run="$docker_run --volume $CONFIG_DIR:/mosquitto/config/:ro"
fi

if [ -n "$PASSWORD_FILE" ]; then
  docker_run="$docker_run --volume $PASSWORD_FILE:/mosquitto/config/mosquitto.passwd:ro"
fi

docker_run="$docker_run eclipse-mosquitto:$VERSION"

echo "$docker_run"
sh -c "$docker_run"
