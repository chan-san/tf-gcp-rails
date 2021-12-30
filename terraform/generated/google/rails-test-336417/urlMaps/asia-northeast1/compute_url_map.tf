resource "google_compute_url_map" "tfer--test" {
  default_service = "https://www.googleapis.com/compute/v1/projects/rails-test-336417/global/backendServices/test1"
  name            = "test"
  project         = "rails-test-336417"
}
