

# gcloud Useful comments

## Creating a Google account and a Kubernetes cluster
```
export GKE_CLUSTER=easycrm
export GKE_PROJECT=t-isotope-362402	
export GKE_ZONE=us-east1-b

gcloud container clusters create-auto $GKE_CLUSTER \
	--project=$GKE_PROJECT \
	--zone=$GKE_ZONE
```
## Enabling the APIs
```
gcloud services enable \
	containerregistry.googleapis.com \
	container.googleapis.com
```
## Configure a Service Account

### Create a new service account:
```
export SA_NAME=gkeaccess
```
### Retrieve the email address of the service account you just created:
`gcloud iam service-accounts create ${SA_NAME}`

### Get authentication credentials for the cluster
`gcloud container clusters get-credentials $GKE_CLUSTER`

### Add roles to the service account. Note: Apply more restrictive roles to suit your requirements.
```
export GKE_PROJECT=t-isotope-362402
export SA_EMAIL=gkeaccess@t-isotope-362402.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $GKE_PROJECT \
	--member=serviceAccount:$SA_EMAIL \
	--role=roles/container.admin
gcloud projects add-iam-policy-binding $GKE_PROJECT \
	--member=serviceAccount:$SA_EMAIL \
	--role=roles/storage.admin
gcloud projects add-iam-policy-binding $GKE_PROJECT \
	--member=serviceAccount:$SA_EMAIL \
	--role=roles/container.clusterViewer
```
### Download the JSON keyfile for the service account:
`gcloud iam service-accounts keys create key.json --iam-account=$SA_EMAIL`

### Store the service account key as a secret named GKE_SA_KEY:
`export GKE_SA_KEY=$(cat key.json | base64)`

## Deploy an application to the cluster
```
kubectl create deployment $GKE_CLUSTER \
    --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
```
## To expose your application, run the following kubectl expose command:
`kubectl expose deployment $GKE_CLUSTER --type LoadBalancer --port 80 --target-port 8080`

## Ingress with Nginx - Optional
Example to deploy Ingress controller on GKS
https://cloud.google.com/community/tutorials/nginx-ingress-gke

