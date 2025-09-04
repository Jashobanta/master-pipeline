variable "project_id" {
  description = "The ID of the Google Cloud Project"
  type        = string
}

variable "trigger_name" {
  description = "Name of the Cloud Build Trigger"
  type        = string
}

variable "region" {
  description = "Region where the Cloud Build Trigger will be created"
  type        = string
}

variable "description" {
  description = "Description of the Cloud Build Trigger"
  type        = string
  default     = "Master Trigger"
}

variable "tags" {
  description = "Tags for the Cloud Build Trigger"
  type        = list(string)
  default     = ["terraform"]
}

variable "github_connection_name" {
  description = "GitHub Connection Name"
  type        =  string
}

variable "github_repo_owner" {
  description = "Owner of the GitHub Repository"
  type        = string
}

variable "github_repo_name" {
  description = "Name of the GitHub Repository"
  type        = string
}

variable "branch_name" {
  description = "Name of the Branch to trigger the build"
  type        = string
}

variable "cloudbuild_yaml_path" {
  description = "Path to the cloudbuild.yaml file"
  type        = string
}

variable "service_account_email" {
  description = "Service account email to be used for the Cloud Build Trigger"
  type        = string
}
