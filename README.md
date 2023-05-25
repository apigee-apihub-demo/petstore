# Petstore

This repository contains a tiny implementation of the Petstore API that can be
deployed to Cloud Run or another platform to provide a simple target server
that can be used to test API management systems and clients.

## Developing the Petstore API with the API Registry

Here's a brief exercise that shows how the registry can be used to track and
assist in the process of deploying and managing an instance of the Petstore
API.

### Configure your environment.

This demonstration uses the `gcloud` and `registry` tools,
along with `jq` and `yq` for processing JSON and YAML, respectively. 
- [`gcloud` installation instructions](https://cloud.google.com/sdk/docs/install)
- [`registry` installation instructions](https://github.com/apigee/registry#the-registry-tool)
- [`jq` installation instructions](https://stedolan.github.io/jq/download/)
- [`yq` installation instructions](https://github.com/mikefarah/yq/#install)

To aid in the following, set the `PROJECT` and `REGION` environment variables
to your Google Cloud project and the location where you would like to create
your demo instances. This region does not need to be the one where your
registry is running.

If necessary, log into `gcloud`.

```
gcloud auth login
```

Next, configure `gcloud` with your project and region.

```
gcloud config set project $PROJECT
gcloud config set run/region $REGION
```

Configure the `registry` tool to work with your API Hub and registry.

```
registry config configurations create hosted
registry config set address apigeeregistry.googleapis.com:443
registry config set insecure false
registry config set location global
registry config set project $PROJECT
```

Note that your registry can be in a different project than the one where you
create your demo instances. If so, use `registry config set project` to point
to the appropriate project.

### 1. Register the Petstore API.

The `apis` directory contains API specifications and `registry` metadata to
describe the Petstore API. This can be added to API Hub with the following
command:

```
registry apply -f apis -R
```

Note that we are loading two API specifications for the same version. The
OpenAPI 3.0.0 specification is preferred, but since
[API Gateway](https://cloud.google.com/api-gateway) requires an OpenAPI 2.0
specification, we also include that and save both in the registry.

### 2. Deploy your service backend.

Let's deploy our backend on [Cloud Run](https://cloud.google.com/run). The
following will build and deploy your service in the configured region.

```
gcloud run deploy petstore --source .
```

Alternately, you can deploy your backend with the button below:

[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run)

### 3. Register your backend deployment.

Now let's create an entry in API Hub for the backend that we've just deployed.

```
# Generate a deployment YAML with information from gcloud.
./tools/GENERATE-BACKEND-DEPLOYMENT.sh

# Apply the deployment YAML to the registry.
registry apply -f backend-deployment.yaml
```

### 4. Deploy an API Gateway.

Next we can create an [API Gateway](https://cloud.google.com/api-gateway) proxy
for our backend API.

```
./tools/DEPLOY-APIGATEWAY.sh
```

### 5. Register your API Gateway deployment.

Let's add this gateway to our registry.

```
# Generate a deployment YAML with information from gcloud.
./tools/GENERATE-APIGATEWAY-DEPLOYMENT.sh

# Apply the deployment YAML to the registry.
registry apply -f gateway-deployment.yaml
```

### 6. (optional) Clean up.

```
# Delete the backend and gateway resources.
./tools/CLEANUP.sh

# Remove the petstore entries from the registry.
registry delete apis/petstore -f
```

## Disclaimer

This demonstration is not an officially supported Google product.

## License

Unless otherwise specified, all content is owned by Google, LLC and released
with the Apache license.

The Petstore OpenAPI specification is copyrighted by the
[OpenAPI Initiative](https://www.openapis.org/).
