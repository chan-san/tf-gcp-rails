// cf. https://cloud.google.com/blog/ja/products/serverless/serverless-load-balancing-terraform-hard-way

locals {
  domain = {
    "default" : var.domain,
    "assets" : "assets.${var.domain}",
    "images" : "img.${var.domain}"
  }
}

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

resource "google_compute_url_map" "default" {
  name            = var.service_name
  default_service = google_compute_backend_service.web.id

  host_rule {
    hosts = [
      local.domain.assets
    ]
    path_matcher = "path-matcher-assets"
  }
  host_rule {
    hosts = [
      local.domain.images
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

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name = "${var.service_name}-cert"
  managed {
    domains = [
      local.domain.default,
      local.domain.assets,
      local.domain.images
    ]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name = "${var.service_name}-https-proxy"

  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

// httpsリダイレクト
resource "google_compute_url_map" "https_redirect" {
  name = "${var.service_name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name    = "${var.service_name}-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_address" "default" {
  name = "${var.service_name}-address"
}

resource "google_compute_global_forwarding_rule" "default" {
  name = var.service_name

  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name = "${var.service_name}-https-redirect"

  target     = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
