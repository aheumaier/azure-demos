AZ=`which az`
LOCATION='westus2'
CLUSTERNAME='ReDIkubo'
RESOURCEGROUP='kuboRG'

# Don't modify beyond this point
if [[ $AZ =~ *az* ]] 
then 
    echo 'ERROR: Azure Cli az not found '
    exit 1
fi 

# Better Die if exit is not zero
on_error_fail_hard(){
    if [[ $? != 0 ]]
    then
        echo 'ERROR:  Command failed  '
        exit 1
    fi
}

# Create Group 
##az group create --name $RESOURCEGROUP --location $LOCATION
on_error_fail_hard

# Create Azure Container Registry
#az acr create --resource-group $RESOURCEGROUP  --name $CLUSTERNAME --sku Basic
on_error_fail_hard

# Login to registry
az acr login --name $CLUSTERNAME
on_error_fail_hard

# List registry images
az acr list --resource-group $RESOURCEGROUP --output table
on_error_fail_hard

# Registering AKS Provider
az provider register -n Microsoft.ContainerService
on_error_fail_hard

# Creaet the AKS Cluster 
az aks create --resource-group $RESOURCEGROUP  --name $CLUSTERNAME --node-count 1 --generate-ssh-keys
on_error_fail_hard

az aks get-credentials --resource-group $RESOURCEGROUP  --name $CLUSTERNAME
on_error_fail_hard

#iInstall kubectl 
sudo az aks install-cli
on_error_fail_hard

# Show my cluster
kubectl get nodes 
on_error_fail_hard
