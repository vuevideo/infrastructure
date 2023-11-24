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

variable "backend_iam_name" {
  description = "VueVideo Backend Service Account Name"
  type        = string
}

variable "backend_version" {
  description = "Backend Image Version"
  type        = string
}

variable "database_instance_name" {
  type        = string
  description = "Cloud SQL Instance Name"
}

variable "database_name" {
  type        = string
  description = "Cloud SQL Database Name"
}

variable "database_user" {
  type        = string
  description = "Cloud SQL Database User"
  sensitive   = true
}

variable "database_password" {
  type        = string
  description = "Cloud SQL Database Password"
  sensitive   = true
}
