locals {
  repositories = length(trimspace(file("repositories.json"))) > 0 ? jsondecode(file("repositories.json")) : []
  #repositories = jsondecode(file("repositories.json"))
  target_repo_name = "projects/${var.project_id}/locations/${var.region}/connections/${var.github_connection_name}/repositories/${var.github_repo_owner}_${var.github_repo_name}"
  repo_names = [for repo in local.repositories : repo.name]
  repo_exists = contains(local.repo_names,local.target_repo_name)
}

resource "google_cloudbuildv2_repository" "linked_repo" {
  count             = local.repo_exists ? 0 : 1
  project           = var.project_id
  location          = var.region
  name              = "${var.github_repo_owner}_${var.github_repo_name}"
  parent_connection = var.github_connection_name
  remote_uri        = "https://github.com/${var.github_repo_owner}/${var.github_repo_name}.git"
}

resource "google_cloudbuild_trigger" "build_trigger" {
  depends_on = [
    google_cloudbuildv2_repository.linked_repo
  ]
  name        = var.trigger_name
  description = var.description
  location    = var.region
  tags        = var.tags
  
  repository_event_config {
    repository = local.repo_exists ? local.target_repo_name : google_cloudbuildv2_repository.linked_repo[0].id
    push {
      branch = var.branch_name
    }
  }

  filename = var.cloudbuild_yaml_path

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
}
