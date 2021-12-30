resource "google_app_engine_application" "app" {
  location_id = local.app_engine_location_id
}
