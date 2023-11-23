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

variable "k8s_network_name" {
  description = "K8s Network Name"
  type        = string
}

variable "k8s_subnet_name" {
  description = "K8s Subnet Name"
  type        = string
}

variable "k8s_subnet_range" {
  description = "K8s Subnet Range"
  type        = string
}
