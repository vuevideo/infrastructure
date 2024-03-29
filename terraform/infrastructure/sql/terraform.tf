terraform {
  required_version = "1.3.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.61.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.61.0"
    }
  }
  backend "gcs" {
    prefix = "sql"
  }
}
