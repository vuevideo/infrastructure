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

# K8s Network Configuration
variable "k8s_network_name" {
  description = "VPC Network Name"
  type        = string
}

# K8s Cluster Configuration
variable "release" {
  description = "Release boolean"
  type        = bool
}

variable "cluster_name" {
  description = "K8s Cluster Name"
  type        = string
}

variable "pool_name" {
  description = "K8s Cluster Node Pool Name"
  type        = string
}

variable "pool_count" {
  description = "Number of VMs in Node Pool"
  type        = number
}

variable "pool_machine_preemptible" {
  description = "Preemptible VM Nodes"
  type        = bool
}

variable "pool_machine_type" {
  description = "Node Pool Machine Type"
  type        = string
}

