#!/bin/sh


account_id=$(3scale-cli accounts list | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1 )
app_id=$(3scale-cli app-plan list -s 11 | awk '{ print $1;}' | while read line && [ -z "$id" ]; do [[ ! "$line" =~ ^[0-9]+$ ]] || id=$line echo $line; done | head -n 1)

3scale-cli applications --account $account_id --plan $app_id --name test --description test create
