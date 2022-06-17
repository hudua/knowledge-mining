#!/bin/bash
## USAGE  ./deploy-app.sh <RG NAME> <APPSERVICE NAME> <ZIP PACKAGE>
set -xe #echo on

# Define variables

rg_name="$1"
app_service_name="$2"
zip_package="$3"

# Deploy to App Service Package
az webapp config appsettings set --resource-group $rg_name --name $app_service_name --settings ENABLE_ORYX_BUILD="false"
az webapp deploy --resource-group $rg_name --name $app_service_name --src-path $zip_package --type zip --clean true --restart true