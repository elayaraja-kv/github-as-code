variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub user or organization"
  type        = string
}

variable "org_permissions" {
  description = "Organization-level Actions permissions. Set to null to skip."
  type        = any
  default     = null
}

variable "repo_permissions" {
  description = "Map of repo name => Actions permissions config"
  type        = map(any)
  default     = {}
}
