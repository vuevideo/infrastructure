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

# Cloud SQL Configuration
variable "database_name" {
  type        = string
  description = "Cloud SQL Database Name"
}

variable "database_instance_name" {
  type        = string
  description = "Cloud SQL Instance Name"
}

variable "database_version" {
  type        = string
  description = "Cloud SQL Version"
}

variable "database_tier" {
  type        = string
  description = "Cloud SQL Machine Tier"
}

variable "database_availability" {
  type        = string
  description = "Cloud SQL Availability"
}

variable "database_user" {
  type        = string
  description = "Cloud SQL Database User"
}

variable "database_password" {
  type        = string
  description = "Cloud SQL Database Password"
}


