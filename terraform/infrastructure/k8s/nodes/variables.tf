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

variable "ci_cd_email" {
  description = "CI/CD Service Account Email"
  type        = string
}

# K8s Cluster Configuration
variable "k8s_node_locations" {
  description = "K8s Nodes Location"
  type        = set(string)
}

variable "cluster_name" {
  description = "K8s Cluster Name"
  type        = string
}

# Backend Pool Configuration

variable "backend_iam_name" {
  description = "VueVideo Backend Service Account Name"
  type        = string
}

variable "backend_pool_roles" {
  description = "Backend Pool Service Account Roles"
  type        = list(string)
  default     = ["roles/logging.configWriter"]
}

variable "backend_pool_name" {
  description = "K8s Cluster Backend Node Pool Name"
  type        = string
}

variable "backend_pool_count" {
  description = "Number of VMs in Backend Node Pool"
  type        = number
}

variable "backend_pool_machine_preemptible" {
  description = "Preemptible VM Backend Nodes"
  type        = bool
}

variable "backend_pool_machine_type" {
  description = "Backend Node Pool Machine Type"
  type        = string
}

# Frontend Pool Configuration
variable "frontend_iam_name" {
  description = "VueVideo Frontend Service Account Name"
  type        = string
}

variable "frontend_pool_roles" {
  description = "Frontend Pool Service Account Roles"
  type        = list(string)
  default     = ["roles/logging.configWriter"]
}

variable "frontend_pool_name" {
  description = "K8s Cluster Frontend Node Pool Name"
  type        = string
}

variable "frontend_pool_count" {
  description = "Number of VMs in Frontend Node Pool"
  type        = number
}

variable "frontend_pool_machine_preemptible" {
  description = "Preemptible VM Frontend Nodes"
  type        = bool
}

variable "frontend_pool_machine_type" {
  description = "Frontend Node Pool Machine Type"
  type        = string
}
