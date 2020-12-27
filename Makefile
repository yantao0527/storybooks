PROJECT_ID=devops-storybooks-298103

run-local:
	docker-compose up

###

create-tf-backend-bucket:
	gsutil mb -p $(PROJECT_ID) gs://$(PROJECT_ID)-terraform

###

check-env:
ifndef ENV
	$(error Please set ENV=[staging|prod])
endif

define get-secret
$(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
endef

###

terraform-create-workspace: check-env
	cd terraform && \
	  terraform workspace new $(ENV)

terraform-init: check-env
	cd terraform && \
	  terraform workspace select $(ENV) && \
	  terraform init

terraform-action: check-env
	cd terraform && \
	  terraform workspace select $(ENV) && \
	  terraform $(TF_ACTION) \
	    --var-file="./environments/common.tfvars" \
	    --var-file="./environments/$(ENV)/config.tfvars" \
		--var="mongodbatlas_private_key=$(call get-secret,mongodbatlas_private_key)" \
		--var="mongodbatlas_user_password=$(call get-secret,mongodbatlas_user_password_$(ENV))" \
        --var="cloudflare_api_token=$(call get-secret,cloudflare_api_token)"

###
SSH_STRING=trial@storybooks-vm-$(ENV)
ZONE=us-central1-c

ssh: check-env
	gcloud compute ssh $(SSH_STRING) \
	  --project=$(PROJECT_ID) \
	  --zone=$(ZONE)

ssh-cmd: check-env
	@gcloud compute ssh $(SSH_STRING) \
	  --project=$(PROJECT_ID) \
	  --zone=$(ZONE) \
	  --command="$(CMD)"

GITHUB_SHA?=latest
LOCAL_TAG=storybooks-app:$(GITHUB_SHA)
REMOTE_TAG=gcr.io/$(PROJECT_ID)/$(LOCAL_TAG)
CONTAINER_NAME=storybooks

build:
	docker build -t $(LOCAL_TAG) .
	
push: check-env
	docker tag $(LOCAL_TAG) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

deploy: check-env
	$(MAKE) ssh-cmd CMD='docker-credential-gcr configure-docker'
	@echo "pulling new container imaged..."
	$(MAKE) ssh-cmd CMD='docker pull $(REMOTE_TAG)'
	@echo "remove old container..."
	-$(MAKE) ssh-cmd CMD='docker container stop $(CONTAINER_NAME)'
	-$(MAKE) ssh-cmd CMD='docker container rm $(CONTAINER_NAME)'
	@echo "starting new container..."
	@$(MAKE) ssh-cmd CMD='\
	  docker run -d --name=$(CONTAINER_NAME) \
	  -p 80:3000 \
	  -e PORT=3000 \
	  -e GOOGLE_CLIENT_ID=198472928897-s3t52550nf05866uqsjaif6557iv7cda.apps.googleusercontent.com \
	  -e GOOGLE_CLIENT_SECRET=$(call get-secret,google_client_secret) \
	  $(REMOTE_TAG) \
	  '