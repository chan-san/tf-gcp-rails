provider "google" {
  project = "rails-test-336417"
}

terraform {
	required_providers {
		google = {
	    version = "~> 3.65.0"
		}
  }
}
