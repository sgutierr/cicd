SERVICE_NAME=$1
SWAGGER=$2
API='API'
SERVICE_ID=$(3scale-cli services list | grep $SERVICE_NAME | awk '{ print $1 }')

3scale-cli import swagger -f $SWAGGER -p "{method}{path}" -m true --service $SERVICE_ID
3scale-cli activedocs create --systemName $SERVICE_NAME $API -f $SWAGGER 
# Create two application plans (basic and unlimited)
aplication_plan_basic_id=$(3scale-cli app-plan create --service $SERVICE_ID --plan Basic | awk '{ print $10; }')