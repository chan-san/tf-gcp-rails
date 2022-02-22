output "gcp_project" {
  value = data.google_project.project.project_id
}

output "google_client_config" {
  value = {
    region  = data.google_client_config.this.region
    project = data.google_client_config.this.project
  }
}

output "test" {
  value = module.load_balancing.test
}
