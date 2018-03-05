#!/bin/sh
ID1=$1
SRC=$2
DEST=$3
NAME=$4
# Copy service
3scale-copy service $ID1 -t $NAME --source $SRC --destination $DEST