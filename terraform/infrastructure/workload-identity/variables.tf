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

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-pool"
}

variable "provider_id" {
  default     = "github-provider"
  description = "Workload Identity Provider ID"
  type        = string
}

variable "sa_mapping" {
  description = "Service Account Mapping for setting up Workload Identity Federation"
  type = map(object({
    sa_name   = string
    attribute = string
  }))
}
