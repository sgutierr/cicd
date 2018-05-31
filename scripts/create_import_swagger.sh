#!/bin/sh

SWG=$1
VERS=$(more $SWG | grep version | cut -d '"' -f4 | head -1)
BASE_NAME=$(more $SWG | grep title | cut -d '"' -f4 | head -1)

MAJOR=$(echo $VERS | cut -d "." -f1)

SERVICE_NAME=$BASE_NAME-v$VERS
echo $SERVICE_NAME

SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')

# Check if service already exist
if [ -z "$SERVICE_ID" ];
  then
  # Create a new service because is a new release
  3scale-cli services create --serviceName $SERVICE_NAME
  SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')
  echo New service
  else
  # Drop service
  3scale-cli services delete -s $SERVICE_ID -c $SERVICE_NAME 
  echo Delete service
  # Create a new service for this minor release.
  3scale-cli services create --serviceName $SERVICE_NAME
  SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')
  echo Recreate service
  
fi
# Import Swagger defintion
3scale-cli import swagger -f $SWG -p "{method}{path}" -m true --service $SERVICE_ID
3scale-cli activedocs create --systemName $SERVICE_NAME -f $SWG 
# Create an application plan to test service status
aplication_plan_basic_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Basic | awk '{ print $10; }')
account_id=$(3scale-cli accounts list | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )
plan_id=$(3scale-cli app-plan list -s $SERVICE_ID | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1)
app_id=$(3scale-cli applications create --account $account_id --plan $plan_id --name app_to_remove --description test | grep " id:" | awk '{ print $2;}')

api_test_path=$(3scale-cli proxy show -s $SERVICE_ID | grep api_test_path | awk '{ print $2;}')
sanbox_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep sandbox_endpoint: | awk '{ print $2;}')
sanbox_endpoint=$(echo "$sanbox_endpoint" | tr '[_]' '-')
backend_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep api_backend: | awk '{ print $2;}' | head -n 1)
production_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep endpoint: | awk '{ print $2;}' | head -n 1)
production_endpoint=$(echo "$production_endpoint" | tr '[_]' '-')

3scale-cli proxy update -s $SERVICE_ID -S $sanbox_endpoint -e $production_endpoint -b $backend_endpoint


