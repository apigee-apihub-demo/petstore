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

# This script removes configuration that was added by SETUP-ACTION.sh.
# It should be run from the root of this repository, e.g.
#   % ./tools/SETUP-ACTION.sh

# Note that if you run this and re-run SETUP-ACTION.sh, you will need to
# specify a new POOL_ID.

# Load some common configuration. See this file for user-editable values.
source ./tools/CONFIG-ACTION.sh

# Delete the service account.
gcloud iam service-accounts delete ${SERVICE_ACCOUNT}

# Delete the workload identity pool and all its child resources.
gcloud iam workload-identity-pools delete ${POOL_ID} --location=global
