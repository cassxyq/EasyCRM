export GKE_CLUSTER=easycrm
export GKE_PROJECT=t-isotope-362402	
export GKE_ZONE=us-east1-b

gcloud container clusters create $GKE_CLUSTER \
	--project=$GKE_PROJECT \
	--zone=$GKE_ZONE

gcloud services enable \
	containerregistry.googleapis.com \
	container.googleapis.com

export SA_NAME=gkeaccess

gcloud iam service-accounts create ${SA_NAME}

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