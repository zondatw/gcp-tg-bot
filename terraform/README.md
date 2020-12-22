# Terraform Deploy

## My environment

Terraform v0.13.5  
gcloud SDK 319.0.0  

## Instructions

* Create Project
* Create service account download key.json and assigned owner role
* `cd terraform/`
* Create terraform.tfvars file
    ```text
    project = "my-project"
    key_path = "key.json path"
    bot_token = "telegram-token"
    scheduler_hitcon_zeroday_crawler_schedule = "schedule" // default: 0 11 * * * (11 a.m. everyday)
    ```
* Enable cloudresourcemanager: `gcloud service enable cloudresourcemanager.googleapis.com`
* Init: `terraform init`  
* deploy: `terraform apply`  