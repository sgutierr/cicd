#!/bin/sh

3scale-cli import swagger -f /cicd/swaggers/payment_swagger.json -p "{method}{path}" -m true -s $SERVICE_ID
3scale-cli activedocs create --systemName PaymentsAPI  -f /cicd/swaggers/payment_swagger.json

aplication_plan_basic_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Basic | awk '{ print $10; }')
aplication_plan_unlimited_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Unlimited | awk '{ print $10; }')

metric_id=$(3scale-cli metrics list -s $SERVICE_ID | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )
metric_unlimited_id=$metric_id

3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $metric_id --period day --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period week --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_basic_id --metric $((metric_id+1)) --period eternity --unit 0


3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_unlimited_id --metric $metric_unlimited_id --period day --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_unlimited_id --metric $((metric_unlimited_id+1)) --period week --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_unlimited_id --metric $((metric_unlimited_id+1)) --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan $aplication_plan_unlimited_id --metric $((metric_unlimited_id+1)) --period eternity --unit 0