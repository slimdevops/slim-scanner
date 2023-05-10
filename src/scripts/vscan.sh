#!/bin/bash


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


echo Starting Vulnerability Scan : "${PARAM_IMAGE}"

jsonData="${VSCAN_REQUEST}"
command=vscan
jsonDataUpdated=${jsonData//__CONNECTOR_ID__/${connectorId}}
jsonDataUpdated=${jsonDataUpdated//__NAMESPACE__/${nameSpace}}
jsonDataUpdated=${jsonDataUpdated//__REPO__/${entity}}
jsonDataUpdated=${jsonDataUpdated//__COMMAND__/${command}}
jsonDataUpdated=${jsonDataUpdated//__TAG__/${tag}}


#Starting Vulnarability Scan
vscanRequest=$(curl -u ":${SLIM_API_TOKEN}" -X 'POST' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "${jsonDataUpdated}")






executionId=$(jq -r '.id' <<< "${vscanRequest}")

#Starting Vulnarability Scan Status Check
echo Starting Vulnerability Scan status check : "${PARAM_IMAGE}"



executionStatus="unknown"
while [[ ${executionStatus} != "completed" ]]; do
	executionStatus=$(curl -s -u :"${SLIM_API_TOKEN}" "${apiDomain}"/orgs/"${SLIM_ORG_ID}"/engine/executions/"${executionId}" | jq -r '.state')
    printf 'current NX state: %s '"$executionStatus \n"
    [[ "${executionStatus}" == "failed" || "${executionStatus}" == "null" ]] && { echo "Vulnerability scan failed - exiting..."; exit 1; }
    sleep 3
done

printf 'Vulnerability scan Completed state= %s '"$executionStatus \n"
#Fetching the report of Vulnarability Scan
echo Fetching Vulnerability scan report : "${PARAM_IMAGE}"

vscanReport=$(curl -L -u ":${SLIM_API_TOKEN}" -X 'GET' \
  "${apiDomain}/orgs/${SLIM_ORG_ID}/engine/executions/${executionId}/result/report" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json')

shaId=$(jq -r '.image.digest' <<< "${vscanReport}")
connectorData=$(jq -r '.image.connector' <<< "${vscanReport}")
IFS='.' read -ra arr <<< "$connectorData"
secondPart=${arr[1]}
firstPart=${arr[0]}
if [ "${secondPart}" = "public" ];then
  urlProfile="https://portal.slim.dev/home/xray/${firstPart}%3A%2F%2F${connectorData}%2F${nameSpace}%2F${entity}%3A${tag}%40sha256%3A${shaId}"
else
  urlProfile="https://portal.slim.dev/home/xray/${connectorData}%3A%2F%2F${connectorId}%2F${nameSpace}%2F${entity}%3A${tag}%40sha256%3A${shaId}"
fi

echo "${vscanReport}" >> /tmp/artifact-vscan;#Report will be added to Artifact
readmeData="${README}"

readmeDataUpdated=${readmeData//__PROFILE__/${urlProfile}}
echo "${readmeDataUpdated}" >> /tmp/artifact-readme;





