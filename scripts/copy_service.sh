#!/bin/sh
SERVICE_NAME=$1
SRC=$2
DEST=$3
# Copy service
ID=$(3scale-cli services list | grep $SERVICE_NAME | awk '{ print $1 }')
3scale-copy service $ID1 -t "$(date "+%Y%m%d%H%M")" --source $SRC --destination $DEST