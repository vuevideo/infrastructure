variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes Cluster Name"
}

variable "frontend_iam_name" {
  description = "VueVideo Frontend Service Account Name"
  type        = string
}

variable "frontend_version" {
  description = "Frontend Image Version"
  type        = string
}
