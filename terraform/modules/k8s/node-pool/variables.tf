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

variable "pool_service_account" {
  description = "Node Pool Service Account"
  type        = string
}

variable "taints" {
  description = "K8s Taints to apply to node pool"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
}

variable "autoscaling_config" {
  description = "Autoscaling configuration"
  type = object({
    total_min_count = number
    total_max_count = number
    max_count       = number
    min_count       = number
  })
  default = {
    total_max_count = 2
    max_count       = 2
    min_count       = 1
    total_min_count = 1
  }
}


