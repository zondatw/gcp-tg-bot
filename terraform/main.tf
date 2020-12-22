provider "google" {
  version     = "3.51.0"
  credentials = file(var.key_path)
  project     = var.project
  region      = var.region
}

// generate bucket name
provider "random" {}

resource "random_string" "bucket-name" {
  length  = 5
  special = false
  number  = false
  upper   = false
}

data "google_project" "project" {
  project_id = var.project
}

resource "google_project_service" "resourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "services" {
  project = data.google_project.project.project_id
  for_each = toset([
    "appengine.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudscheduler.googleapis.com",
  ])
  service            = each.value
  disable_on_destroy = false

  disable_dependent_services = false

  depends_on = [
    google_project_service.resourcemanager,
  ]
}

resource "null_resource" "pack" {
  provisioner "local-exec" {
    command = "cd ../ && zip -r ${var.deploy_zip_name} ${var.deploy_zip_file_list}"
  }
}

resource "google_storage_bucket_object" "deploy_file" {
  depends_on = [
    null_resource.pack,
  ]

  name   = var.deploy_zip_name
  source = "../${var.deploy_zip_name}"
  bucket = google_storage_bucket.deploy_bucket.name
}

resource "google_app_engine_standard_app_version" "app_v1" {
  version_id = "v1"
  service    = "default"
  runtime    = "python37"

  entrypoint {
    shell = "gunicorn -b :$PORT --threads=4 main:app"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.deploy_bucket.name}/${google_storage_bucket_object.deploy_file.name}"
    }
  }

  delete_service_on_destroy = true
}

resource "google_cloud_scheduler_job" "hitcon_zeroday_crawler_job" {
  depends_on = [
    google_app_engine_application.app,
  ]

  name        = "hitcon-zeroday-crawler-trigger"
  description = "Trigger hitcon-zeroday-crawler"
  schedule    = var.scheduler_hitcon_zeroday_crawler_schedule
  time_zone   = var.scheduler_hitcon_zeroday_crawler_timezone

  retry_config {
    retry_count = 1
  }

  app_engine_http_target {
    http_method = "GET"

    app_engine_routing {
      service = "default"
    }

    relative_uri = "/hitcon_zeroday_crawler"
  }
}
