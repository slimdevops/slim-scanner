#!/bin/bash

IMAGE_CONNECTOR="${CONNECTOR_ID}"
if [ -z "$IMAGE_CONNECTOR" ]; then
    echo "CONNECTOR_ID missing. Please add CONNECTOR_ID to the environment variables section."
    exit 1
fi
if [ -z "${SLIM_API_TOKEN}" ]; then
    echo "SLIM_API_TOKEN missing. Please add SLIM_API_TOKEN to the environment variables section."
    exit 1
fi
if [ -z "${SLIM_ORG_ID}" ]; then
    echo "SLIM_ORG_ID missing. Please add SLIM_ORG_ID to the environment variables section."
    exit 1
fi
string="${IMAGE_CONNECTOR}/${PARAM_IMAGE}"
match=$(echo "${string}" | grep -oP '^(?:([^/]+)/)?(?:([^/]+)/)?([^@:/]+)(?:[@:](.+))?$')
IFS='/' 
read -r -a parts <<< "$match"
namespace=${parts[1]}
repository=${parts[2]}

if [ -z "$repository" ]; then
  repository="${namespace}"
  namespace="library"
fi
if echo "$repository" | grep -q ":"; then
  IFS=':' read -ra arr <<< "$repository"
  tag=${arr[1]}
  repository=${arr[0]}
else
  tag="latest"
fi
if [ -z "$namespace" ]; then
  namespace="library"
fi
connectorId="${IMAGE_CONNECTOR}"
nameSpace="${namespace}"
entity="${repository}"
apiDomain="https://platform.slim.dev"
#echo Starting X-Ray Scan : "${PARAM_IMAGE}"
jsonData="${XRAY_REQUEST}"
command=xray
jsonDataUpdated=${jsonData//__CONNECTOR_ID__/${connectorId}}
jsonDataUpdated=${jsonDataUpdated//__NAMESPACE__/${nameSpace}}
jsonDataUpdated=${jsonDataUpdated//__REPO__/"${entity}"}
jsonDataUpdated=${jsonDataUpdated//__COMMAND__/${command}}
jsonDataUpdated=${jsonDataUpdated//__TAG__/${tag}}
#Starting Xray Scan
xrayRequestResponse=$(curl -s -o - -w "\n%{http_code}" -u ":${SLIM_API_TOKEN}" -X 'POST' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "${jsonDataUpdated}")

response_code=$(tail -n1 <<< "$xrayRequestResponse")  # Extract the last line (HTTP response code)

if [ "$response_code" != "200" ]; then
    echo "Error: Engine execution failed for Xray. HTTP response code: $response_code"
    exit 1
fi
xrayRequest=$(head -n -1 <<< "$xrayRequestResponse") 
executionId=$(jq -r '.id' <<< "${xrayRequest}")
#Fetching the status of X-ray scan
#echo Starting X-Ray Scan status check : "${PARAM_IMAGE}"
executionStatus="unknown"
while [[ ${executionStatus} != "completed" ]]; do
	executionStatus=$(curl -s -u :"${SLIM_API_TOKEN}" "${apiDomain}"/orgs/"${SLIM_ORG_ID}"/engine/executions/"${executionId}" | jq -r '.state')
    printf 'current NX state: %s '"$executionStatus \n"
    [[ "${executionStatus}" == "failed" || "${executionStatus}" == "null" ]] && { echo "XRAY failed - exiting..."; exit 1; }
    sleep 3
done
#printf 'XRAY Completed state= %s '"$executionStatus \n"
#Fetching the X-ray Report
echo Fetching XRAY report : "${PARAM_IMAGE}"
response=$(curl -s -o - -w "\n%{http_code}" -L -u ":${SLIM_API_TOKEN}" -X 'GET' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions/${executionId}/result/report" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json')
response_code=$(tail -n1 <<< "$response")  # Extract the last line (HTTP response code)
if [ "$response_code" != "200" ]; then
    echo "Error: Failed to fetch xrayReport. HTTP response code: $response_code"
    exit 1
fi
xrayReport=$(head -n -1 <<< "$response")  # Extract the content without the last line (response code)
echo "${xrayReport}" >> /tmp/artifact-xray;#Uploading report to Artifact




