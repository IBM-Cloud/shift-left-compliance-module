#!/usr/bin/env bash

#// https://github.com/open-toolchain/sdk/wiki/Toolchain-Creation-page-parameters#headless-toolchain-creation-and-update

# log in using the api key
ibmcloud login --apikey "$API_KEY" -r "$REGION" 

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

#Reserved for command to get

PARAMETERS="autocreate=true&apiKey=$API_KEY"`
`"&sourceRepoUrl=$APPLICATION_REPO&pipeline_repo=$PIPELINE_REPO&tektonCatalogRepo=$PIPELINE_REPO"`
`"&registryRegion=$REGION&registryNamespace=$REGISTRY_NAMESPACE&devRegion=$REGION"`
`"&devResourceGroup=$RESOURCE_GROUP&devClusterName=$CLUSTER_NAME&devClusterNamespace=$CLUSTER_NAMESPACE"`
`"&toolchainName=$TOOLCHAIN_NAME&pipeline_type=$PIPELINE_TYPE"`
`"&artifactoryUserId=$ART_USER_ID&artifactoryToken=$ART_TOKEN&onePipelineConfigRepo=$APPLICATION_REPO"`
`"&evidenceRepo=$EVIDENCE_REPO&issuesRepo=$ISSUES_REPO&inventoryRepo=$INVENTORY_REPO"`
`"&cosBucketName=$COS_BUCKET_NAME&cosEndpoint=$COS_URL&vaultSecret=$VAULT_SECRET"
#echo $PARAMETERS

RESPONSE=$(curl -i -X POST \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -H "Authorization: $BEARER_TOKEN" \
  "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&$PARAMETERS")

echo "$RESPONSE"
LOCATION=$(grep location <<<"$RESPONSE" | awk {'print $2'})
echo "View the toolchain at: $LOCATION"

exit 0;
