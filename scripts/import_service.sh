#!/bin/sh

3scale-cli import swagger -f /cicd/swaggers/payment_swagger.json -p "{method}{path}" -m true -s $SERVICE_ID
3scale-cli activedocs create --systemName PaymentsAPI  -f /cicd/swaggers/payment_swagger.json

// Application plan Basic
3scale-cli app-plan create --service $SERVICE_ID --plan Basic
3scale-cli metrics list -s $SERVICE_ID

3scale-cli limits create  --service $SERVICE_ID --appplan 13 --metric 13 --period day --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 13 --metric 14 --period week --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 13 --metric 15 --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 13 --metric 1$SERVICE_ID --period eternity --unit 0
3scale-cli app-plan create --service $SERVICE_ID --plan unlimited


3scale-cli limits create  --service $SERVICE_ID --appplan 14 --metric 13 --period day --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 14 --metric 14 --period week --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 14 --metric 15 --period eternity --unit 0
3scale-cli limits create  --service $SERVICE_ID --appplan 14 --metric 1$SERVICE_ID --period eternity --unit 0