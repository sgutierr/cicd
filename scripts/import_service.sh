#!/bin/sh

SERVICE_ID=$(3scale-cli services list | grep $SERVICE_NAME | awk '{ print $1 }')

3scale-cli import swagger -f /cicd/swaggers/payment_swagger.json -p "{method}{path}" -m true --service $SERVICE_ID
3scale-cli activedocs create --systemName PaymentsAPI  -f /cicd/swaggers/payment_swagger.json 

# Create two application plans (basic and unlimited)
aplication_plan_basic_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Basic | awk '{ print $10; }')
aplication_plan_unlimited_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Unlimited | awk '{ print $10; }')

# Create metrics for v1 and v2 endpoints
3scale-cli metrics -s $SERVICE_ID -m "version1" create
3scale-cli metrics -s $SERVICE_ID -m "version2" create

# Get metric id
metric_id=$(3scale-cli metrics list -s $SERVICE_ID | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )

#Create mapping rules for v1 and V2
3scale-cli maprules -s $SERVICE_ID --http GET -d 1 -p /v1 -m $((metric_id+6)) create
3scale-cli maprules -s $SERVICE_ID --http GET -d 1 -p /v2 -m $((metric_id+7)) create

# Limits for Basic application plan
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $metric_id --period day --unit 10000
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period minute --unit 3
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period hour --unit 50
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period week --unit 2000
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+2)) --period minute --unit 2
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+2)) --period day --unit 200
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+3)) --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+4)) --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+5)) --period eternity --unit 100000
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+6)) --period eternity --unit 0

# Limit for unalimited application plan
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_unlimited_id --metric $((metric_id+4)) --period eternity --unit 0

# Features
curl -k -X POST  $APIM'/admin/api/services/'$SERVICE_ID'/features.xml' -d 'access_token='$ACCESS_TOKEN'&name=Free&system_name=Free'
curl -k -X POST  $APIM'/admin/api/services/'$SERVICE_ID'/features.xml' -d 'access_token='$ACCESS_TOKEN'&name=Limited&system_name=Limited'
curl -k -X POST  $APIM'/admin/api/services/'$SERVICE_ID'/features.xml' -d 'access_token='$ACCESS_TOKEN'&name=Unlimited&system_name=Unlimited'
curl -k -X POST  $APIM'/admin/api/services/'$SERVICE_ID'/features.xml' -d 'access_token='$ACCESS_TOKEN'&name=Contracts&system_name=Contract'