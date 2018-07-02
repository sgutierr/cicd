#!/bin/sh
SERVICE_NAME=$1
SWG=$2
lastVersion=$3


if [ -z "$2" ];
then
  SERVICE_ID=$(3scale-cli services list | grep $SERVICE_NAME | awk '{ print $1 }')
# parameter swagger path exists we find out service_name
else
  # get version field
  VERS=$(more $SWG | grep version | cut -d '"' -f4 | head -1)
  # get title field
  BASE_NAME=$(more $SWG | grep title | cut -d '"' -f4 | head -1)
  MAJOR=$(echo $VERS | cut -d "." -f1)

  #Compose service name
  SERVICE_NAME=$BASE_NAME-v$VERS
  echo Service name:$SERVICE_NAME
  SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')
  echo $SERVICE_ID
fi

# There is not version specified 
if [ -z "$3" ];
 then
 lastVersion=$(3scale-cli proxy-configs list -s $SERVICE_ID -e sandbox | awk '{ print $2;}' | tail -n 2) 
fi

# productionVersion=$(3scale-cli proxy-configs list -s $SERVICE_ID -e production | awk '{ print $2;}' | tail -n 2) 

# Get production version
#if [ $lastVersion \> $productionVersion ];
# then
3scale-cli proxy-configs promote -s $SERVICE_ID -e sandbox -c $lastVersion
# else
# echo Staging and production have the same version: $productionVersion
# fi



