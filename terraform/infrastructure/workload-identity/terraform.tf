terraform {
  required_version = "1.3.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.6.0"
    }
  }
  backend "gcs" {
    prefix = "workload-identity"
  }
}
