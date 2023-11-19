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

variable "gcp_services_list" {
  description = "The list of GCP APIs necessary for deployment."
  type        = list(string)
}
