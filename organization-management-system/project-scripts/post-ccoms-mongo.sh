#!/opt/homebrew/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

HOST_NAME=localhost
PROXY_PORT=8111

JSON_FILES_DIR="$SCRIPTPATH/../../kubernetes/ansible_k8s-ccoms-deployment/scripts/post_ccoms/json_files"

[[ ! -f $JSON_FILES_DIR/emps.json ]] && echo "file not available" && exit 1

EMP_JSONFILE="$JSON_FILES_DIR/emps.json"
DEPT_JSONFILE="$JSON_FILES_DIR/departments.json"
ORG_JSONFILE="$JSON_FILES_DIR/organization.json"


curl -X POST -H "Content-Type: application/json" -d @$EMP_JSONFILE http://$HOST_NAME:$PROXY_PORT/emp/api/addemps
curl -X POST -H "Content-Type: application/json" -d @$DEPT_JSONFILE http://$HOST_NAME:$PROXY_PORT/dept/api/adddepts
curl -X POST -H "Content-Type: application/json" -d @$ORG_JSONFILE http://$HOST_NAME:$PROXY_PORT/org/api/addorgs

[[ $? -ne 0 ]] && echo "command got failed" && exit 1 