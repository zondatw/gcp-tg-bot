resource "google_storage_bucket" "deploy_bucket" {
  location = var.storage_location
  name     = "deploy-bucket-${random_string.bucket-name.result}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = "3"
    }

    action {
      type = "Delete"
    }
  }
}
