#!/bin/sh
SUBDOMAIN=$1
ACCESS_TOKEN=$2
WILDCARD_DOMAIN=$3
# Create a new creedentials.json

echo '{ "threescale": {  "id": "'$SUBDOMAIN'", "access_token": "'$ACCESS_TOKEN'", "wildcard": "'$WILDCARD_DOMAIN'"  }}' >> $HOME/.3scale/credentials.json
