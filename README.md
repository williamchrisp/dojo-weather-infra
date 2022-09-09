

# William Chrisp Pathways Dojo Infra Node Weather App Infrastructure

This repository is used in conjunction with the Contino Infra Engineer to Cloud Engineer Pathway course delivered in Contini-U. It is the main infrastructure half of the weather app and the app half is located in the following repository. 
https://github.com/williamchrisp/dojo-weather-app

It includes and supports the following functionality:
* Dockerfile and docker-compose configuration for 3M based deployments
* Makefile providing Terraform deployment functionality
* GitHub workflows for supporting Terraform deploy and destroy functionality

<br> 


## Running Locally

The provided `makefile`, `dockerfile` , and `docker-compose.yml` files work together to create a docker container which is used to run Terraform deployments and other supported commands. It expects AWS account credentials to be passed as environment variables.

Please ensure the following variables are exported locally.
if you are not using temporary credentials you do not require AWS_SESSION_TOKEN
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```

To run a simple aws command, ensure you have set your *__aws temporary credentials__* in your local environment and run the following

```
make list_bucket
```

Deploying Terraform environment locally - creates tfplan file during plan as input to apply. Apply is auto-approved.

```
make run_plan
make run_apply
```

Destroying Terraform environment locally. Destroy plan is speculative. Destroy apply is auto-approved.

```
make run_destroy_plan
make run_destroy_apply
```
Terraform `init`, `validate` and `fmt` are run for each of the `make` commands above.

For more information on 3 Musketeers deployment method, visit the official site here. https://3musketeers.io/

<br> 

## GitHub Actions / Workflows
The following workflows are provided in this repository. These are located under `.github/workflows`.

| Workflow | Description | Environments | Trigger
|----------|-------------|--------------|--------|
| main.yml | Two step workflow to run a Terraform Plan and Terraform Apply following manual approvals. | approval | on.push.branch [master] ||
| destroy.yml | Two step workflow to run a speculative Terraform Destroy Plan and Terraform Destroy following manual approvals. | approval | on.push.branch [destroy] ||

Note: Pushing to `master` branch will trigger Terraform (TF) deploy. You will also need to create a branch named `destroy` in your GitHub repository. Not required locally and only used for pull requests `master -> destroy` to trigger TF destroy workflow.

Additionally, ONLY changes to the following files and paths will trigger a workflow.

```
    paths:
      - 'docker-compose.yml'
      - 'Makefile'
      - '.github/workflows/**'
      - '*dockerfile'
      - 'modules/**'
      - '**.tf'
```

<br>

### main.yml workflow
![Main Workflow](images/main.yml_workflow.png)

<br>

### destroy.yml workflow
![Destroy Workflow](images/destroy.yml_workflow.png)

<br>

Create an environment in your repository named `approval` to support GitHub Workflows, selecting `required reviewers` adding yourself as an approver.

<br> 

![GitHub Environment](images/github_environment.png)

<br> 

## GitHub Secrets
Create GitHub Secrets in your repository for `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` if using temporary credentials. ONLY `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` required if you have configured an IAM user with programmatic access.

<br>

## Terraform IaC
The Terraform environment is setup to get you started. This includes `providers.tf`, `meta.tf`, `variables.tf` and `main.tf` which leverages the `.tf` modules created in `modules/`. 

The `modules` folder allows you to organise your `.tf` files are called by `main.tf`.

### Inputs
---
<details open>
  <summary>Click to expand</summary>


| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_cidr | Specifies the cidr for the vpc | string | `"10.0.0.0/24"` | yes |
| public_subnets | Specifies the public subnets in a list | list(any) | `"10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"` | yes |
| private_subnets | Specifies the private subnets in a list | list(any) | `"10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26"` | yes |
| bucket | S3 bucket name - must be globally unique | string | `"williamdojoapp"` | yes |
| tags | Tags to be applied to AWS resources| map(string) | `Owner   = "williamchrisp", Project = "node-weather-app"` | yes |


</details>

<br> 

<!-- OUTPUTS -->
### Outputs
---
<details open>
  <summary>Click to expand</summary>

| Name | Description |
|------|-------------|
| bucket_name | The name of the S3 Bucket. | |
| bucket_name_arn | The ARN of the S3 Bucket. | |


</details>

<br>

### TF State Files
AWS S3 is used to host the TF state files. This is hosted by s3://pathways-dojo, you can change this to whatever pre-created bucket. You will need to update the name of the state file in the `meta.tf` file replacing `williamchrisp` with your username.

```
terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = williamchrisp-tfstate
    region = "us-east-1"
  }
}
```

Happy Hacking!
