#!/bin/sh

# Create a new creedentials.json

echo '{ "threescale": {  "id": "'$ID'", "access_token": "'$ACCESS_TOKEN'", "wildcard": "'$WILDCARD_DOMAIN'"  }}' >> $HOME/.3scale/credentials.json
