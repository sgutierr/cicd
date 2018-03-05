#!/bin/sh
ID1=$1
ID2=$2
SRC=$3
DEST=$4
# Create a new service
3scale-update service $ID1 $ID2 --source $SRC --destination $DEST