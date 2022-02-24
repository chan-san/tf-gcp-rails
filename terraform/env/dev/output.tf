output "gcp_project" {
  value = data.google_project.project.project_id
}

output "google_client_config" {
  value = {
    region  = data.google_client_config.this.region
    project = data.google_client_config.this.project
  }
}

output "load_balancer_ip_address" {
  value = module.load_balancing.global_ip_address
}

output "service_accounts" {
  value = {
    deployment_account  = module.service_account.deployment_account.email
    app_account         = module.service_account.app_account.email
    run_invoker_account = module.service_account.run_invoker_account.email
  }
}
