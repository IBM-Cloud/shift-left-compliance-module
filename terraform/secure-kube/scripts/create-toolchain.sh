#!/usr/bin/env bash

#// https://github.com/open-toolchain/sdk/wiki/Toolchain-Creation-page-parameters#headless-toolchain-creation-and-update

# log in using the api key
ibmcloud login --apikey "$API_KEY" -r "$REGION" 

# target default resource group for now
ibmcloud target -g default

# get the bearer token to create the toolchain instance
IAM_TOKEN="IAM token:  "
BEARER_TOKEN=$(ibmcloud iam oauth-tokens | grep "$IAM_TOKEN" | sed -e "s/^$IAM_TOKEN//")
#echo $BEARER_TOKEN

# prefix region for toolchains
TOOLCHAIN_REGION=$REGION
if [[ ! $TOOLCHAIN_REGION =~ "ibm:" ]]; then
  export TOOLCHAIN_REGION="ibm:yp:$REGION"
fi

#RESOURCE_GROUP_ID=$(ibmcloud resource group $RESOURCE_GROUP --output JSON | jq ".[].id" -r)

# create secrets manager service
# NOTE: Secrets Manager service can take approx 5-8 minutes to provision
SM_SERVICE_NAME="compliance-ci-secrets-manager"
ibmcloud resource service-instance-create $SM_SERVICE_NAME secrets-manager lite us-south
echo "Waiting up to 8 minutes for Secrets Manager service to provision..."
wait=480
count=0
sleep_time=60
while [[ $count -le $wait ]]; do
  ibmcloud resource service-instances >services.txt
  secretLine=$(cat services.txt | grep $SM_SERVICE_NAME)
  stringArray=($secretLine)
  if [[ "${stringArray[2]}" != "active" ]]; then
    echo "Secrets Manager status: ${stringArray[2]}"
    count+=$sleep_time
    if [[ $count > $wait ]]; then
      echo "Secrets Manager took longer than 8 minutes to provision"
      echo "Something must have gone wrong. Exiting."
      exit 1
    else
      echo "Waiting 60 seconds to check again..."
      sleep $sleep_time
    fi
  else
    echo "Secrets Manager status: ${stringArray[2]}"
    break
  fi
done

# generate gpg key
gpg --batch --gen-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 2048
Subkey-Type: 1
Subkey-Length: 2048
Name-Real: Root User
Name-Email: root@compliance.ci.ibm.com
Expire-Date: 0
EOF
gpg --export-secret-key -a "Root User"  | base64 > private.key
export VAULT_SECRET=$(cat private.key)

PARAMETERS="autocreate=true&apiKey=$API_KEY&onePipelineConfigRepo=$APPLICATION_REPO"`
`"&sourceRepoUrl=$APPLICATION_REPO&pipeline_repo=$PIPELINE_REPO&tektonCatalogRepo=$PIPELINE_REPO"`
`"&registryRegion=$TOOLCHAIN_REGION&registryNamespace=$REGISTRY_NAMESPACE&devRegion=$REGION"`
`"&devResourceGroup=$RESOURCE_GROUP&devClusterName=$CLUSTER_NAME&devClusterNamespace=$CLUSTER_NAMESPACE"`
`"&toolchainName=$TOOLCHAIN_NAME&pipeline_type=$PIPELINE_TYPE"`
`"&evidenceRepo=$EVIDENCE_REPO&issuesRepo=$ISSUES_REPO&inventoryRepo=$INVENTORY_REPO"`
`"&cosBucketName=$COS_BUCKET_NAME&cosEndpoint=$COS_URL&vaultSecret=$VAULT_SECRET"`
`"&smName=$SM_NAME&smRegion=$REGION&smResourceGroup=$RESOURCE_GROUP&smInstanceName=$SM_SERVICE_NAME"
echo "PARAMETERS:"
echo $PARAMETERS
echo "URL:"
echo "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&$PARAMETERS"

RESPONSE=$(curl -i -X POST \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -H "Authorization: $BEARER_TOKEN" \
  "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&$PARAMETERS")

echo "$RESPONSE"
LOCATION=$(grep location <<<"$RESPONSE" | awk {'print $2'})
echo "View the toolchain at: $LOCATION"

exit 0;
