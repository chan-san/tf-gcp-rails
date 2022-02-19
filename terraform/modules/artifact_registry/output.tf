output "app" {
  value = local.app
}

output "repository_path" {
  value = "${local.app.location}-docker.pkg.dev/${local.app.project}/${local.app.repository_id}/"
}
