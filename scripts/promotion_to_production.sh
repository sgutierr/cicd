#!/bin/sh
SWG=$1
lastVersion=$2

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

# There is not version specified
if [ -z "$lastVersion" ];
 then
 lastVersion=$(3scale-cli proxy-configs list -s $SERVICE_ID -e sandbox | awk '{ print $2;}' | tail -n 2)
fi

3scale-cli proxy-configs promote -s $SERVICE_ID -e sandbox -c $lastVersion




