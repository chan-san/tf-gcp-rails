module "google_project_service" {
  source = "../../modules/google_project_service"
}

# Resources

module "app_engine" {
  source   = "../../modules/app_engine"
  env      = var.env
  location = var.location
}

module "service_account" {
  source   = "../../modules/service_account"
  env      = var.env
  location = var.location
}

module "networking" {
  source   = "../../modules/networking"
  env      = var.env
  location = var.location
  servicenetworking = module.google_project_service.servicenetworking
}

module "secrets" {
  source   = "../../modules/secrets"
  env      = var.env
  location = var.location
}

module "artifact_registry" {
  source             = "../../modules/artifact_registry"
  env                = var.env
  location           = var.location
  deployment_account = module.service_account.deployment_account
}

module "cloud_tasks" {
  source                 = "../../modules/cloud_tasks"
  env                    = var.env
  location               = var.location
  google_project_service = module.google_project_service.cloud_tasks
}

module "cloud_sql" {
  source   = "../../modules/cloud_sql"
  env      = var.env
  location = var.location
  private_vpc_connection = module.networking.cloud_sql_private_vpc_connection
}

module "storage" {
  source   = "../../modules/storage"
  env      = var.env
  location = var.location
  project  = var.project_id
}

module "load_balancing" {
  source             = "../../modules/load_balancing"
  env                = var.env
  location           = var.location
  bucket_name_assets = module.storage.assets.name
}

module "cloud_run" {
  source          = "../../modules/cloud_run"
  env             = var.env
  location        = var.location
  repository_path = module.artifact_registry.repository_path
  image_sha       = var.image_sha
  force           = var.force
  app_account     = module.service_account.app_account
  cloud_sql_vpc_connector = module.networking.cloud_sql_vpc_connector
  secrets = module.secrets.items
}

module "cloud_scheduler" {
  source      = "../../modules/cloud_scheduler"
  env         = var.env
  region      = module.app_engine.app.location_id
  worker_url  = module.cloud_run.worker_url
  run_account = module.cloud_run.run_account
}
