resource "google_compute_backend_bucket" "assets" {
  name        = var.buckets.assets.name
  description = "assets"
  bucket_name = var.buckets.assets.name
  enable_cdn  = true
  cdn_policy {
    client_ttl        = 86400
    default_ttl       = 86400
    max_ttl           = 31536000
    serve_while_stale = 0
  }
}

resource "google_compute_backend_bucket" "images" {
  name        = var.buckets.images.name
  description = "assets"
  bucket_name = var.buckets.images.name
  enable_cdn  = true
  cdn_policy {
    client_ttl        = 86400
    default_ttl       = 86400
    max_ttl           = 31536000
    serve_while_stale = 0
  }
}

// resource "google_compute_global_forwarding_rule" "sample" {
//   provider = google-beta
//   name = "tf-gcp-rails2"
//   target = "all-apis"
// }

// resource "google_compute_forwarding_rule" "tf-gcp-rails" {
// }

// resource "google_compute_global_forwarding_rule" "tf-gcp-rails" {
// }

/*
// Forwarding rule for Regional External Load Balancing
resource "google_compute_global_forwarding_rule" "tf-gcp-rails" {
  provider = google-beta
  depends_on = [google_compute_subnetwork.proxy]
  name   = "website-forwarding-rule"
  region = "us-central1"

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.default.id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}

resource "google_compute_region_target_http_proxy" "default" {
  provider = google-beta

  region  = "us-central1"
  name    = "website-proxy"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_region_url_map" "tf-gcp-rails" {
  provider = google-beta

  region          = "asia-northeast-1"
  name            = "website-map"
  //default_service = google_compute_region_backend_service.default.id
}*/