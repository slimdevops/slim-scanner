#!/bin/bash
apiDomain="https://platform.slim.dev"
portalDomain="https://portal.slim.dev"
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
#echo Starting Vulnerability Scan : "${PARAM_IMAGE}"
jsonData="${VSCAN_REQUEST}"
command=vscan
jsonDataUpdated=${jsonData//__CONNECTOR_ID__/${connectorId}}
jsonDataUpdated=${jsonDataUpdated//__NAMESPACE__/${nameSpace}}
jsonDataUpdated=${jsonDataUpdated//__REPO__/${entity}}
jsonDataUpdated=${jsonDataUpdated//__COMMAND__/${command}}
jsonDataUpdated=${jsonDataUpdated//__TAG__/${tag}}
#Starting Vulnarability Scan
vscanRequestResponse=$(curl -s -o - -w "\n%{http_code}" -u ":${SLIM_API_TOKEN}" -X 'POST' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "${jsonDataUpdated}")
response_code=$(tail -n1 <<< "$vscanRequestResponse")  # Extract the last line (HTTP response code)
if [ "$response_code" != "200" ]; then
    echo "Error: Engine execution failed for Vscan. HTTP response code: $response_code"
    exit 1
fi
vscanRequest=$(head -n -1 <<< "$vscanRequestResponse") 
executionId=$(jq -r '.id' <<< "${vscanRequest}")
#Starting Vulnarability Scan Status Check
#echo Starting Vulnerability Scan status check : "${PARAM_IMAGE}"
executionStatus="unknown"
while [[ ${executionStatus} != "completed" ]]; do
	executionStatus=$(curl -s -u :"${SLIM_API_TOKEN}" "${apiDomain}"/orgs/"${SLIM_ORG_ID}"/engine/executions/"${executionId}" | jq -r '.state')
    printf 'current NX state: %s '"$executionStatus \n"
    [[ "${executionStatus}" == "failed" || "${executionStatus}" == "null" ]] && { echo "Vulnerability scan failed - exiting..."; exit 1; }
    sleep 3
done
printf 'Vulnerability scan Completed state= %s '"$executionStatus \n"
#Fetching the report of Vulnarability Scan
#echo Fetching Vulnerability scan report : "${PARAM_IMAGE}"
response=$(curl -s -o - -w "\n%{http_code}" -L -u ":${SLIM_API_TOKEN}" -X 'GET' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions/${executionId}/result/report" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json')
response_code=$(tail -n1 <<< "$response")  # Extract the last line (HTTP response code)
if [ "$response_code" != "200" ]; then
    echo "Error: Failed to fetch vscanReport. HTTP response code: $response_code"
    exit 1
fi
vscanReport=$(head -n -1 <<< "$response") 
shaId=$(jq -r '.image.digest' <<< "${vscanReport}")
connectorData=$(jq -r '.image.connector' <<< "${vscanReport}")
IFS='.' read -ra arr <<< "$connectorData"
secondPart=${arr[1]}
firstPart=${arr[0]}
if [ "${secondPart}" = "public" ];then
  urlProfile="${portalDomain}/home/xray/${firstPart}%3A%2F%2F${connectorData}%2F${nameSpace}%2F${entity}%3A${tag}%40sha256%3A${shaId}"
else
  urlProfile="${portalDomain}/home/xray/${connectorData}%3A%2F%2F${connectorId}%2F${nameSpace}%2F${entity}%3A${tag}%40sha256%3A${shaId}"
fi
echo "${vscanReport}" >> /tmp/artifact-vscan; #Report will be added to Artifact
readmeData="${README}"
readmeDataUpdated=${readmeData//__PROFILE__/${urlProfile}}
echo "${readmeDataUpdated}" >> /tmp/artifact-readme;





