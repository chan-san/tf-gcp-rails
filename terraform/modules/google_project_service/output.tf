output "cloud_tasks" {
  value = google_project_service.cloudtasks
}
output "servicenetworking" {
  value = google_project_service.servicenetworking
}
output "compute" {
  value = google_project_service.compute
}
output "secretmanager" {
  value = google_project_service.secretmanager
}
output "artifactregistry" {
  value = google_project_service.artifactregistry
}
