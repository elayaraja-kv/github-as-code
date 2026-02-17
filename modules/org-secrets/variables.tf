variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "org_secrets" {
  description = <<-EOT
    Map of org-level Actions secrets. Key is secret name. Value:
    - value: string (the secret value)
    - visibility: "all", "private", or "selected"
    - selected_repository_ids: list of repo IDs (when visibility is "selected")
  EOT
  type      = map(any)
  default   = {}
  sensitive = true
}
