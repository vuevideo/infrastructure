# GCP Provider 
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

# K8s Service Account Configuration
variable "k8s_account_id" {
  description = "ID for the K8s service account"
  type        = string
}

variable "k8s_display_name" {
  description = "Display name for the K8s service account"
  type        = string
}

variable "k8s_roles" {
  description = "Array of roles to grant to K8s."
  type        = list(string)
}

