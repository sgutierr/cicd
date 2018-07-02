#!/bin/sh
SERVICE_NAME=$1
SRC=$2
DEST=$3
SWG=$4

if [ -z "$4" ];
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
3scale-copy service $SERVICE_ID -t "$(date "+%Y%m%d%H%M")" --source $SRC --destination $DEST