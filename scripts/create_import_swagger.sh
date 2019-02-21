#!/bin/sh

SWG=$1
TOKEN=$2
# get version field 
VERS=$(more $SWG | grep version | cut -d '"' -f4 | head -1)
# get OIDC protocol
PROTOCOL=$(more $SWG | grep '"type" : "oauth2"')
# get title field
BASE_NAME=$(more $SWG | grep title | cut -d '"' -f4 | head -1)
MAJOR=$(echo $VERS | cut -d "." -f1)
echo $BASE_NAME $MAJOR
PATCH=$(echo $((RANDOM%10000)))
#Compose service name
SERVICE_NAME=$BASE_NAME-v$VERS.$PATCH
echo Service name:$SERVICE_NAME

SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')

# Check if service already exist
if [ -z "$SERVICE_ID" ];
  then
  # Create a new service because is a new release
  3scale-cli services create --serviceName $SERVICE_NAME
  SERVICE_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $1 }')

  echo New service:$SERVICE_ID
  else
  # Rename service
  RENAME_SERVICE="https://3scale-admin.5.9.49.249.xip.io/admin/api/services/"$SERVICE_ID".xml"
  echo $RENAME_SERVICE
  curl -v -k -X PUT $RENAME_SERVICE -d 'access_token='$TOKEN'&name='$SERVICE_NAME

fi

if [ -z "$PROTOCOL" ];
  then
  # By default API_KEY
   echo "API key authentication method"
  else
  echo $"OIDC authentication method"
  # Setup OIDC in service
  OIDC_SERVICE="https://3scale-admin.5.9.49.249.xip.io/admin/api/services/"$SERVICE_ID".xml"
  echo $OIDC_SERVICE
  curl -v -k -X PUT $OIDC_SERVICE -d 'access_token='$TOKEN'&backend_version=oidc'
  # Setup OIDC endpoint issuer in service
  ISSUER_ENDPOINT=$(more $SWG | grep authorizationUrl | cut -d '"' -f4 | head -1)
  curl -v -k -X PUT $OIDC_SERVICE -d 'access_token='$TOKEN'&oidc_issuer_endpoint='$ISSUER_ENDPOINT

fi 

SYSTEM_ID=$(3scale-cli services list | grep $BASE_NAME-v$MAJOR | awk '{ print $4 }')
# Import Swagger defintion
3scale-cli import swagger -f $SWG -p "{method}{path}" -m true --service $SERVICE_ID
# Delete existing ActiveDocs and create new version
AD_ID=$(3scale-cli activedocs list | grep $SYSTEM_ID | awk '{ print $1 }')
3scale-cli activedocs delete -s $AD_ID
3scale-cli activedocs create -s $SYSTEM_ID -f $SWG 

api_test_path=$(3scale-cli proxy show -s $SERVICE_ID | grep api_test_path | awk '{ print $2;}')
sanbox_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep sandbox_endpoint: | awk '{ print $2;}')
sanbox_endpoint=$(echo "$sanbox_endpoint" | tr '[_]' '-')
sanbox_endpoint=$(echo "$sanbox_endpoint" | sed 's/ging'/'.api/')
backend_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep api_backend: | awk '{ print $2;}' | head -n 1)
production_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep endpoint: | awk '{ print $2;}' | head -n 1)
production_endpoint=$(echo "$production_endpoint" | tr '[_]' '-')
production_endpoint=$(echo "$production_endpoint" | sed 's/ction'/'.api/')

3scale-cli proxy update -s $SERVICE_ID -S $sanbox_endpoint -e $production_endpoint -b $backend_endpoint

# Create two application plans (basic and unlimited)
aplication_plan_basic_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Basic | awk '{ print $10; }')


