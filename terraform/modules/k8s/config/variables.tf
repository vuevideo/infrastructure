variable "cluster_name" {
  description = "K8s Cluster Name"
  type        = string
}

variable "location" {
  description = "K8s Cluster Location"
  type        = string
}

variable "node_locations" {
  description = "K8s Nodes Location"
  type        = set(string)
}

variable "network_name" {
  description = "K8s VPC Name"
  type        = string
}

variable "subnet_name" {
  description = "K8s Subnet Name"
  type        = string
}

variable "pods_ipv4_cidr_block" {
  description = "K8s Pods IP CIDR Range"
  type        = string
}

variable "services_ipv4_cidr_block" {
  description = "K8s Services IP CIDR Range"
  type        = string
}

variable "control_plane_ipv4_cidr_block" {
  description = "K8s Control Plane IP CIDR Range"
  type        = string
}

variable "pool_name" {
  description = "K8s Cluster Node Pool Name"
  type        = string
}

variable "pool_location" {
  description = "K8s Cluster Node Pool Location"
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

# variable "pool_service_account_email" {
#   description = "Node Pool Service Account Email"
#   type        = string
# }


