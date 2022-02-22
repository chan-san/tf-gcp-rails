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

resource "google_compute_region_network_endpoint_group" "cloudrun_web_neg" {
  provider              = google-beta
  name                  = "${var.service_name}-web-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.location
  cloud_run {
    service = var.cloud_run_apps.web.name
  }
}

resource "google_compute_backend_service" "web" {
  name = "${var.service_name}-web-backend"

  protocol                        = "HTTP"
  port_name                       = "http"
  timeout_sec                     = 30
  connection_draining_timeout_sec = 40

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_web_neg.id
  }
}

resource "google_compute_url_map" "main" {
  name            = var.service_name
  default_service = google_compute_backend_service.web.id

  host_rule {
    hosts = [
      "assets.${var.domain}",
    ]
    path_matcher = "path-matcher-assets"
  }
  host_rule {
    hosts = [
      "img.${var.domain}",
    ]
    path_matcher = "path-matcher-images"
  }

  path_matcher {
    default_service = google_compute_backend_bucket.assets.self_link
    name            = "path-matcher-assets"
  }
  path_matcher {
    default_service = google_compute_backend_bucket.images.self_link
    name            = "path-matcher-images"
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