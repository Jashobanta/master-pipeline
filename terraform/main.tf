locals {
  repositories = jsondecode(file("${path.module}/"repositories.json"))
  repo_map = {for repo in local.repositories : repo.name => repo }
}

resource "google_cloudbuildv2_repository" "linked_repo" {
  for_each = local.repo_map
  #count             = local.repo_exists ? 0 : 1
  project           = var.project_id
  location          = var.region
  name              = each.value.name
  parent_connection = var.github_connection_name
  remote_uri        = each.value.remote_uri
}

resource "google_cloudbuild_trigger" "build_trigger" {
  for_each = google_cloudbuildv2_repository.linked_repo
  name        = "auto-trigger-${each.key}"
  description = "automated trigger for ${each.key}"
  location    = var.region
  
  repository_event_config {
    repository = each.value.id
    push {
      branch = each.value.defaultBranch
    }
  }

  filename = var.cloudbuild_yaml_path

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
}
