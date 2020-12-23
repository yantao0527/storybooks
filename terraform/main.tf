terraform {
  backend "gcs" {
    bucket = "devops-storybooks-298103-terraform"
    prefix = "/state/storybooks"
  }
}