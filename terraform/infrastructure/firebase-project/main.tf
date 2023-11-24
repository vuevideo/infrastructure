# Services required for firebase to run with.
resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = var.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "serviceusage.googleapis.com",
    "firebasestorage.googleapis.com",
    "identitytoolkit.googleapis.com"
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
resource "google_storage_bucket" "profile-pictures" {
  provider                    = google-beta
  name                        = var.firebase_bucket_name
  location                    = "asia-south1"
  uniform_bucket_level_access = true
}

resource "google_firebase_storage_bucket" "default" {
  provider  = google-beta
  project   = google_firebase_project.firebase_project.project
  bucket_id = google_storage_bucket.profile-pictures.id
}

# Create a ruleset of Firebase Security Rules from a local file.
resource "google_firebaserules_ruleset" "storage" {
  provider = google-beta
  project  = var.project_id
  source {
    files {
      name    = "storage.rules"
      content = "service firebase.storage {match /b/${var.firebase_bucket_name}/o {match /{allPaths=**} {allow read, write: if request.auth != null;}}}"
    }
  }

  depends_on = [
    google_firebase_storage_bucket.default
  ]
}

# Firebase Authentication
resource "google_identity_platform_config" "default" {
  project                    = google_firebase_project.firebase_project.project
  autodelete_anonymous_users = true
  sign_in {
    email {
      enabled           = true
      password_required = false
    }
  }
  authorized_domains = [
    "localhost",
    "${google_firebase_project.firebase_project.project}.firebaseapp.com",
    "${google_firebase_project.firebase_project.project}.web.app",
  ]
}
