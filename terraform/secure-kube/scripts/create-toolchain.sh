#!/usr/bin/env bash

#// https://github.com/open-toolchain/sdk/wiki/Toolchain-Creation-page-parameters#headless-toolchain-creation-and-update

# log in using the api key
ibmcloud login --apikey "$API_KEY" -r "$REGION"

# target default resource group for now
ibmcloud target -g $RESOURCE_GROUP 

# get the bearer token to create the toolchain instance
IAM_TOKEN="IAM token:  "
BEARER_TOKEN=$(ibmcloud iam oauth-tokens | grep "$IAM_TOKEN" | sed -e "s/^$IAM_TOKEN//")
#echo $BEARER_TOKEN

# prefix region for toolchains
TOOLCHAIN_REGION=$REGION
if [[ ! $TOOLCHAIN_REGION =~ "ibm:" ]]; then
  export TOOLCHAIN_REGION="ibm:yp:$REGION"
fi

RESOURCE_GROUP_ID=$(ibmcloud resource group $RESOURCE_GROUP --output JSON | jq ".[].id" -r)

# check for the existence of the Secrets Manager instance
SM_FOUND=$(bx resource service-instance "$SM_SERVICE_NAME" --output JSON | jq ".[].name" -r)
if [[ $SM_FOUND ]]; then
  echo "Secrets Manager '$SM_SERVICE_NAME' already exists."
else
  echo "Creating Secrets Manager service..."
  # NOTE: Secrets Manager service can take approx 5-8 minutes to provision
  ibmcloud resource service-instance-create $SM_SERVICE_NAME secrets-manager lite $REGION
  wait_secs=600
  count=0
  sleep_time=60
  wait_mins=$(($wait_secs / $sleep_time))
  echo "Waiting up to $wait_mins minutes for Secrets Manager service to provision..."
  while [[ $count -le $wait_secs ]]; do
    ibmcloud resource service-instances >services.txt
    secretLine=$(cat services.txt | grep $SM_SERVICE_NAME)
    stringArray=($secretLine)
    if [[ "${stringArray[2]}" != "active" ]]; then
      echo "Secrets Manager status: ${stringArray[2]}"
      count=$(($count + $sleep_time))
      if [[ $count -gt $wait_secs ]]; then
        echo "Secrets Manager service took longer than $wait_mins minutes to provision."
        echo "You might have to re-configure this integration in the toolchain once the service finally provisions."
      else
        echo "Waiting $sleep_time seconds to check again..."
        sleep $sleep_time
      fi
    else
      echo "Secrets Manager successfully provisioned"
      echo "Status: ${stringArray[2]}"
      break
    fi
  done
fi

# generate gpg key
gpg --batch --pinentry-mode loopback --generate-key <<EOF
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

# URL encode VAULT_SECRET, TOOLCHAIN_TEMPLATE_REPO, APPLICATION_REPO, and API_KEY
export VAULT_SECRET=$(echo $VAULT_SECRET | jq -rR @uri)
export TOOLCHAIN_TEMPLATE_REPO=$(echo $TOOLCHAIN_TEMPLATE_REPO | jq -rR @uri)
export APPLICATION_REPO=$(echo $APPLICATION_REPO | jq -rR @uri)
export API_KEY=$(echo $API_KEY | jq -rR @uri)
export appName=$APP_NAME

PARAMETERS="autocreate=true&appName=$APP_NAME&apiKey=$API_KEY&onePipelineConfigRepo=$APPLICATION_REPO&configRepoEnabled=true"`
`"&repository=$TOOLCHAIN_TEMPLATE_REPO&repository_token=$GITLAB_TOKEN&branch=$BRANCH"`
`"&sourceRepoUrl=$APPLICATION_REPO&resourceGroupId=$RESOURCE_GROUP_ID"`
`"&registryRegion=$TOOLCHAIN_REGION&registryNamespace=$REGISTRY_NAMESPACE&devRegion=$REGION"`
`"&devResourceGroup=$RESOURCE_GROUP&devClusterName=$CLUSTER_NAME&devClusterNamespace=$CLUSTER_NAMESPACE"`
`"&toolchainName=$TOOLCHAIN_NAME&pipeline_type=$PIPELINE_TYPE&gitToken=$GITLAB_TOKEN"`
`"&cosBucketName=$COS_BUCKET_NAME&cosEndpoint=$COS_URL&vaultSecret=$VAULT_SECRET"`
`"&smName=$SM_NAME&smRegion=$REGION&smResourceGroup=$RESOURCE_GROUP&smInstanceName=$SM_SERVICE_NAME"

# debugging
#echo "$PARAMETERS"
# adding some sleep time, so hopefully the toolchain will see the recently provisioned Secrets Manager
sleep 10

RESPONSE=$(curl -i -X POST \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -H "Authorization: $BEARER_TOKEN" \
  "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&$PARAMETERS")

echo "$RESPONSE"
LOCATION=$(grep location <<<"$RESPONSE" | awk {'print $2'})
echo "View the toolchain at: $LOCATION"

exit 0;
