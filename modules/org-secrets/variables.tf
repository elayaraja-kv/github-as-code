variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "gcp_project" {
  description = "GCP project ID for Secret Manager lookups"
  type        = string
}

variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "gcp_secrets_name" {
  description = <<-EOT
    Name of a single GCP Secret Manager secret whose value is a JSON map of
    GitHub secret name -> plaintext value. Example secret value:
    {"ORG_DEPLOY_TOKEN": "ghp_xxx", "NPM_TOKEN": "npm_xxx"}
  EOT
  type    = string
  default = null
}

variable "org_secrets" {
  description = <<-EOT
    Per-secret metadata overrides. Key is the GitHub secret name (must match a
    key in the GCP SM JSON). Supported fields:
    - visibility: "all", "private", or "selected" (default: "all")
    - selected_repository_ids: list of repo IDs (required when visibility = "selected")
  EOT
  type    = map(any)
  default = {}
}
