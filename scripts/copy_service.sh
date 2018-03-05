#!/bin/sh
ID1=$1
ID2=$2
SRC=$3
DEST=$4
# Copy service
/home/sgutierr/.bashrc
3scale-copy service $ID1 -t copy_service --source $SRC --destination $DEST

