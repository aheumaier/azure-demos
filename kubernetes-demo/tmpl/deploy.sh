#!/usr/bin/env bash 

RG='aksDev'
LOCATION='eastus'

function ensureSuccess() {
    $($1)
    if [ $? -eq 0 ]
    then
        exit 1
    fi
}
# Validate Templare 
ensureSuccess "az group deployment validate --resource-group $RG --template-file azuredeploy.json --parameters @azuredeploy.parameters.json"


# Ensure resouce group
#ensureSuccess "az group create --name $RG --location $LOCATION"
#ensureSuccess "az group create --name ${RG}Networking --location $LOCATION"
#ensureSuccess "az group create --name ${RG}Cluster --location $LOCATION"


# Go for network deployment
ensureSuccess "az group deployment create --resource-group ${RG}Networking --template-file network.json --parameters @azuredeploy.parameters.json"

# Go for clusterdeployment
#ensureSuccess "az group deployment create --resource-group $RG --template-file azuredeploy.json --parameters @azuredeploy.parameters.json"