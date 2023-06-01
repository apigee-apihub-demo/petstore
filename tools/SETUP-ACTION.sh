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

# This script configures a Google Cloud project to allow a GitHub Action
# associated with this repository to make mutating calls to the Registry API.
# It should be run from the root of this repository, e.g.
#   % ./tools/SETUP-ACTION.sh

# Load some common configuration. See this file for user-editable values.
source ./tools/CONFIG-ACTION.sh

# Create a service account that will be used to perform actions on the registry.
gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID} \
  --display-name="Registry Editor"

# Give the service account the "apigeeregistry.editor" role.
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member=serviceAccount:${SERVICE_ACCOUNT} \
  --role=roles/apigeeregistry.editor

# Create a workload identity pool that will contain our identity provider.
gcloud iam workload-identity-pools create ${POOL_ID} \
  --project=${PROJECT_ID} \
  --location=global \
  --display-name="GitHub Actions Activity Pool"

# Create a provider that creates an identity for requests coming from
# a GitHub repo running an action. The requests must be associated with
# the GITHUB_OWNER that we specify.
gcloud iam workload-identity-pools providers create-oidc ${PROVIDER_ID} \
  --project=${PROJECT_ID} \
  --location=global \
  --workload-identity-pool=${POOL_ID} \
  --display-name="Registry Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.owner=assertion.repository_owner" \
  --attribute-condition="attribute.owner == '${GITHUB_OWNER}'" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Add a binding that allows any identity from our workload identity
# pool to act as the service account that we created.
gcloud iam service-accounts add-iam-policy-binding ${SERVICE_ACCOUNT} \
  --project=${PROJECT_ID} \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/*"
