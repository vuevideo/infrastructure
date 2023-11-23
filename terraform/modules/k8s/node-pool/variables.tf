variable "cluster_name" {
  description = "K8s Cluster Name"
  type        = string
}

variable "node_locations" {
  description = "K8s Nodes Location"
  type        = set(string)
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


