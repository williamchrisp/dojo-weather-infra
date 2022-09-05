# Compose Commands
COMPOSE_RUN_TERRAFORM = docker-compose run --rm tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf

# Terraform Pipeline and Local Commands
.PHONY: run_plan run_apply run_destroy_plan run_destroy_apply
run_plan: init plan

run_apply: init apply

run_destroy_plan: init destroy_plan

run_destroy_apply: init destroy_apply

# Individual Terraform Commands
.PHONY: version init plan apply destroy_plan destroy_apply
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	
init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

# List Bucket Command
.PHONY: list_bucket
list_bucket: 
	$(COMPOSE_RUN_AWS) s3 ls