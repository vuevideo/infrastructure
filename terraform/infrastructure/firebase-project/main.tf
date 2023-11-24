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

# Create a ruleset of Firebase Security Rules from a local file.
resource "google_firebaserules_ruleset" "storage" {
  provider = google-beta
  project  = var.project_id
  source {
    files {
      name    = "storage.rules"
      content = <<EOL
      rules_version = '2';

      service firebase.storage {
        match /b/{bucket}/o {
          match /{allPaths=**} {
            allow read, write: if request.auth != null;
          }
        }
      }
      EOL
    }
  }
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
