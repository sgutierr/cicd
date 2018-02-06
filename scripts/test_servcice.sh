#!/bin/sh


account_id=$(3scale-cli accounts list | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )
plan_id=$(3scale-cli app-plan list -s 11 | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1)

app_id=$(3scale-cli applications create --account $account_id --plan $plan_id --name test --description test | grep " id:" | awk '{ print $2;}')


sanbox_endpoint=$(3scale-cli proxy show -s $SERVICE_ID | grep sandbox_endpoint: | awk '{ print $2;}')
api_test_path=$(3scale-cli proxy show -s $SERVICE_ID | grep api_test_path | awk '{ print $2;}')
user_key=$(3scale-cli applications --account $account_id -i $app_id show | grep user_key | awk '{print $2;}')

echo $sanbox_endpoint''$api_test_path'?user_key='$user_key
curl -k $sanbox_endpoint''$api_test_path'?user_key='$user_key