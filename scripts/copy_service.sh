#!/bin/sh
ID1=$1
SRC=$2
DEST=$3
# Copy service
3scale-copy service $ID1 -t "$(date "+%Y%m%d%H%M")" --source $SRC --destination $DEST