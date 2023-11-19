# Services required for firebase to run with.
resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = var.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "serviceusage.googleapis.com",
  ])
  service            = each.key
  disable_on_destroy = false
}

# Create a new firebase project
resource "google_firebase_project" "firebase_project" {
  provider = google-beta
  project  = var.project_id

  # Waits for the required APIs to be enabled.
  depends_on = [
    google_project_service.default
  ]
}

# Buckets for storing profile pictures in.
resource "random_string" "random" {
  length  = 16
  special = false
}

resource "google_storage_bucket" "profile-pictures" {
  provider                    = google-beta
  name                        = "vuevideo-profile-pictures-${random_string.random.result}"
  location                    = "ASIA"
  uniform_bucket_level_access = true
}

resource "google_firebase_storage_bucket" "default" {
  provider  = google-beta
  project   = google_firebase_project.firebase_project.project
  bucket_id = google_storage_bucket.profile-pictures.id
}

# # Firebase Authentication
# resource "google_identity_platform_config" "default" {
#   project                    = google_firebase_project.firebase_project.project
#   autodelete_anonymous_users = true
#   sign_in {
#     email {
#       enabled           = true
#       password_required = false
#     }
#   }
#   authorized_domains = [
#     "localhost",
#     "${google_firebase_project.firebase_project.project}.firebaseapp.com",
#     "${google_firebase_project.firebase_project.project}.web.app",
#   ]
# }
