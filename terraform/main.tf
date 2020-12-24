terraform {
  backend "gcs" {
    bucket = "devops-storybooks-298103-terraform"
    prefix = "/state/storybooks"
  }
  required_providers {
    google = {
      version = "~> 3.51"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 0.7"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.14"
    }
  }
}