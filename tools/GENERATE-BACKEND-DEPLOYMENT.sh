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

PROJECT=$(gcloud config get project)
REGION=$(gcloud config get run/region)
REVISION=$(registry get projects/${PROJECT}/locations/global/apis/petstore/versions/1.0.0/specs/swagger -o raw | jq .[0].revisionId -r)
ADDRESS=$(gcloud run services describe petstore --format "value(status.url)")

cat > backend-deployment.yaml <<EOF
apiVersion: apigeeregistry/v1
kind: Deployment
metadata:
  name: backend
  parent: apis/petstore
  labels:
    platform: cloudrun
    apihub-gateway: apihub-unmanaged
  annotations:
    apihub-external-channel-name: Cloud Run
    region: $REGION
    project: $PROJECT
data:
  displayName: Backend
  description: The backend deployment of the Petstore API
  apiSpecRevision: 1.0.0/specs/swagger@$REVISION
  endpointURI: $ADDRESS
  externalChannelURI: https://console.cloud.google.com/run/detail/$REGION/petstore/metrics?project=$PROJECT
  intendedAudience: Internal
EOF
