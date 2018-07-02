#!/bin/sh
SERVICE_NAME=$1
ENVIRONMENT=$2
ENDPOINT=$4
SWG=$3

if [ -z "$3" ];
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

account_id=$(3scale-cli accounts list | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )
plan_id=$(3scale-cli app-plan list -s $SERVICE_ID | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1)
app_id=$(3scale-cli applications create --account $account_id --plan $plan_id --name app_to_remove --description test | grep " id:" | awk '{ print $2;}')

# If there is not a specific endpoint to check
if [ -z "$4" ];
then
api_test_path=$(3scale-cli proxy show -s $SERVICE_ID | grep api_test_path | awk '{ print $2;}')
sandboxStr=sandbox 

 if [ "$2" == "$sandboxStr" ]
   then
   sanbox_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep sandbox_endpoint: | awk '{ print $2;}')
   ENDPOINT=$sanbox_endpoint''$api_test_path'/';
   else
   production_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep endpoint: | awk '{ print $2;}' | head -n 1)
   ENDPOINT=$production_endpoint''$api_test_path'/';
 fi

fi
# Get user key
user_key=$(3scale-cli applications create --account $account_id -i $app_id -p $plan_id show | grep user_key | awk '{print $2;}')
echo 'Plan id:'$plan_id'App_id:'$app_id' Account_id:'$account_id 
echo $sanbox_endpoint''$api_test_path'?user_key='$user_key

# Check service status  
curl -k $ENDPOINT'?user_key='$user_key

# Remove application
rm=$(3scale-cli applications delete -a $account_id -i $app_id)