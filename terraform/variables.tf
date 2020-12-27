### GENERAL
variable "app_name" {
  type = string
}

### ATLAS

variable "mongodbatlas_project_id" {
  type = string
}

variable "mongodbatlas_public_key" {
  type = string
}

variable "mongodbatlas_private_key" {
  type = string
}

variable "mongodbatlas_user_password" {
  type = string
}

### cloudflare

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

### GCP

variable "gcp_machine_type" {
  type = string
}