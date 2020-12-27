provider "cloudflare" {
  api_token   = var.cloudflare_api_token
}

# Zone
data "cloudflare_zones" "cf_zones" {
  filter {
    name = var.cloudflare_domain
  }
}

# DNS A record
resource "cloudflare_record" "cf_dns" {
  zone_id = data.cloudflare_zones.cf_zones.zones[0].id
  name    = "storybooks${terraform.workspace == "prod" ? "" : "-${terraform.workspace}"}"
  value   = google_compute_address.ip_address.address
  type    = "A"
  proxied = true
}