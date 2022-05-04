#!/bin/bash

# This script will create a toolchain specifically designed for the Roar testing framework.
# This script uses some hard coded values specific to the testing account `arftt@us.ibm.com`.
# See the below syntax on how to execute this script.
# SYNTAX: ./create_roar_tektion_toolchain.sh <prod | ondeck> <API Key>
# Example: ./create_roar_tektion_toolchain.sh prod "APIKEY***"
# NOTE: Make sure the API key and Slack Webhook are for the same test environment and region

if [ "${PIPELINE_DEBUG}" == "1" ]; then
    pwd
    echo "Debugging enabled"
    set -x
fi

export test_env=$1
API_KEY=$2
REGION="us-south"
RESOURCE_GROUP="default"

# log in using the api key
ibmcloud login --apikey "$API_KEY" -r "$REGION" -g "$RESOURCE_GROUP"

# prefix region for toolchains
TOOLCHAIN_REGION=$REGION
if [[ ! $TOOLCHAIN_REGION =~ "ibm:" ]]; then
  export TOOLCHAIN_REGION="ibm:yp:$REGION"
fi

RESOURCE_GROUP_ID=$(ibmcloud resource group $RESOURCE_GROUP --output JSON | jq ".[].id" -r)

SM_NAME="RoarSecretsManager"
SM_REGION="$TOOLCHAIN_REGION"
SM_RESOURCE_GROUP="$RESOURCE_GROUP"

TOOLCHAIN_TEMPLATE_REPO="https://github.com/IBM-Cloud/shift-left-compliance-module"
BRANCH="roartest"
PRIVATE_WORKER_NAME="tekton-roar-$test_env-worker"

# NOTE: the query param enablePDAlerts isn't getting passed down when creating the toolchain
#ENABLE_PD_ALERTS=true

# target CF env
#ibmcloud target --cf-api https://api.us-south.cf.cloud.ibm.com -o devex-governance -s skit-governance

# default to tekton pipelines
PIPELINE_TYPE="tekton"
if [ "$test_env" == "prod" ]; then
  export TOOLCHAIN_NAME="Tekton-Roar-Prod"
else
  export TOOLCHAIN_NAME="Tekton-Roar-Ondeck"
fi
echo "Creating new toolchain $TOOLCHAIN_NAME..."

# URL encode TOOLCHAIN_TEMPLATE_REPO and SM_NAME
export TOOLCHAIN_TEMPLATE_REPO=$(echo "$TOOLCHAIN_TEMPLATE_REPO" | jq -Rr @uri)
export SM_NAME=$(echo "$SM_NAME" | jq -Rr @uri)

# create parameters for headless toolchain
PARAMETERS="autocreate=true&apiKey={vault::$SM_NAME.Default.apikey}"`
`"&repository=$TOOLCHAIN_TEMPLATE_REPO&branch=$BRANCH&testEnv=$test_env"`
`"&resourceGroupId=$RESOURCE_GROUP_ID&gitLabToken={vault::$SM_NAME.Default.gitLabToken}"`
`"&toolchainName=$TOOLCHAIN_NAME&pipeline_type=$PIPELINE_TYPE"`
`"&smName=$SM_NAME&smRegion=$TOOLCHAIN_REGION&smResourceGroup=$RESOURCE_GROUP&smInstanceName=$SM_NAME"`
`"&artApiKey={vault::$SM_NAME.Default.artApiKey}&slackWebhook={vault::$SM_NAME.Default.slack-webhook-roar-$test_env}"`
`"&privateWorkerName=$PRIVATE_WORKER_NAME&privateWorkerCreds={vault::$SM_NAME.Default.tekton-roar-$test_env-testing}"`
`"&privateWorkerIdentifier={vault::$SM_NAME.Default.tekton-roar-$test_env-serviceid}"

# debugging
echo "Here are the parameters:"
echo "$PARAMETERS"
echo "test"

# get a fresh Bearer token
iamtoken=$(ibmcloud iam oauth-tokens | awk '/IAM/{ print $3" "$4 }')

# create headless toolchain
RESPONSE=$(curl -i -X POST \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -H "Authorization: $iamtoken" \
  -d "$PARAMETERS" \
  "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&repository=$TOOLCHAIN_TEMPLATE_REPO&branch=$BRANCH")
echo "$RESPONSE"
LOCATION=$(grep location <<<"$RESPONSE" | awk {'print $2'})
echo "View the toolchain at: $LOCATION"

exit 0;
