resource "google_app_engine_application" "app" {
  depends_on    = [
    google_project_service.services["appengine.googleapis.com"],
    google_project_service.services["cloudbuild.googleapis.com"],
  ]
  location_id   = var.appengine_location
  database_type = "CLOUD_FIRESTORE"

  provisioner "local-exec" {
    command = "curl https://api.telegram.org/bot${var.bot_token}/setWebhook?url=${google_app_engine_application.app.default_hostname}/hook"
  }
}
