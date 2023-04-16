variable "account_id" {
  description = "ID for the service account"
  type        = string
}

variable "display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "roles" {
  description = "Array of roles to grant."
  type        = list(string)
}
