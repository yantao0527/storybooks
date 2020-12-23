provider "google" {
  credentials = file("terraform-sa-key.json")
  project     = "devops-storybooks-298103"
  region      = "us-central1"
  zone        = "us-central1-c"
  version     = "3.51.0"
}

# IP ADDRESS

# NETWORK

# FIREWALL RULE

# OS IMAGE

# COMPUTE ENGINE INSTANCE