#!/bin/sh
SERVICE_NAME=$1
lastVersion=$2
SERVICE_ID=$(3scale-cli services list | grep $SERVICE_NAME | awk '{ print $1 }')


# There is not version specified 
if [ -z "$2" ];
 then
 lastVersion=$(3scale-cli proxy-configs list -s $SERVICE_ID -e sandbox | awk '{ print $2;}' | tail -n 2) 
fi

productionVersion=$(3scale-cli proxy-configs list -s $SERVICE_ID -e production | awk '{ print $2;}' | tail -n 2) 

# Get production version
if [ $lastVersion \> $productionVersion ];
 then
 3scale-cli proxy-configs promote -s $SERVICE_ID -e sandbox -c $lastVersion
 else
 echo Staging and production have the same version: $productionVersion
fi



