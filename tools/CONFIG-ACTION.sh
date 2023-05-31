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

# This file sets variables that allow a GitHub Action associated
# with this repository to use Workload Identity Federation.
#
# There are many possible ways to configure this. For full
# details see the official documentation at:
#   https://cloud.google.com/iam/docs/workload-identity-federation
#
# Here we set variables used by other scripts that allow an action
# running under a specified GitHub owner to use a service account
# that is configured to have edit access to the Registry API.

# ACTION: Set this to the owner of your repo (a GitHub organization
# or user name).
GITHUB_OWNER=apigee-apihub-demo

# ACTION: Set these variables to the name and number of the Google
# Cloud project where your Registry API instance is running.
PROJECT_ID=apigee-apihub-demo
PROJECT_NUMBER=459884772743

# ACTION: Review these names. They are arbitrary and you probably
# won't need to change them. The pool ID and Service Account email
# must match values in your GitHub Action. Note that if you delete
# a pool, its ID will be unusable for a significant period of time
# afterwards (currently 30 days).
POOL_ID=registry
PROVIDER_ID=registry
SERVICE_ACCOUNT_ID=registry-editor

# This automatically derives the full name of the service account that's
# used to call the Registry API. You probably won't need to change it.
SERVICE_ACCOUNT="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"
