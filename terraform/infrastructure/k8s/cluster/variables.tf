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
