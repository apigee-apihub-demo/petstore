#!/bin/bash
#
# Copyright 2023 Google LLC. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

API_ID=petstore
DEPLOYMENT_ID=backend

ADDRESS=$(registry get apis/${API_ID}/deployments/${DEPLOYMENT_ID} -o raw | jq .[0].endpointUri -r)
SPEC=$(registry get apis/${API_ID}/deployments/${DEPLOYMENT_ID} -o raw | jq .[0].apiSpecRevision -r)

PROJECT=$(gcloud config get project)
REGION=$(gcloud config get run/region)

TMPFILE=$(mktemp /tmp/openapi-XXXXXX.yaml)

registry get $SPEC -o contents > ${TMPFILE}
yq -i ".x-google-backend.address = \"$ADDRESS\"" ${TMPFILE}

gcloud api-gateway api-configs create ${API_ID} --api=${API_ID} --project=${PROJECT} --openapi-spec=${TMPFILE}
gcloud api-gateway gateways create ${API_ID} --api=${API_ID} --api-config=${API_ID} --location=${REGION} --project=${PROJECT}

