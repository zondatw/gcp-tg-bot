variable "project" {
  type = string
}

variable "bot_token" {
  type = string
}

variable "key_path" {
  type    = string
  default = "key.json"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "storage_location" {
  type    = string
  default = "us-central1"
}

variable "appengine_location" {
  type    = string
  default = "us-central"
}

variable "deploy_zip_name" {
  type    = string
  default = "artifact.zip"
}

variable "deploy_zip_file_list" {
  type    = string
  default = "apps config models main.py app.yaml requirements.txt .env"
}

variable "scheduler_hitcon_zeroday_crawler_schedule" {
  type    = string
  default = "0 11 * * *"
}

variable "scheduler_hitcon_zeroday_crawler_timezone" {
  type    = string
  default = "Asia/Taipei"
}
