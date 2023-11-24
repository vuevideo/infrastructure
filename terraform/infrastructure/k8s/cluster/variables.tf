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

# K8s Cluster Configuration
variable "k8s_network_name" {
  description = "K8s Network Name"
  type        = string
}

variable "k8s_subnet_name" {
  description = "K8s Subnet Name"
  type        = string
}

variable "k8s_node_locations" {
  description = "K8s Nodes Location"
  type        = set(string)
}

variable "cluster_name" {
  description = "K8s Cluster Name"
  type        = string
}

variable "control_plane_ipv4_cidr_block" {
  description = "Control Plane CIDR Range"
  type        = string
}

variable "pods_ipv4_cidr_block" {
  description = "PODs CIDR Range"
  type        = string
}

variable "services_ipv4_cidr_block" {
  description = "Services CIDR Range"
  type        = string
}

# Default Node Pool Configurations

variable "pool_roles" {
  description = "Pool Service Account Roles"
  type        = list(string)
  default     = ["roles/logging.configWriter"]
}

variable "ci_cd_email" {
  description = "CI/CD Service Account Email"
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
