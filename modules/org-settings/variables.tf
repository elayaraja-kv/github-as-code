variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "name" {
  description = "Organization display name"
  type        = string
  default     = ""
}

variable "billing_email" {
  description = "Billing email for the organization"
  type        = string
  default     = ""
}

variable "company" {
  description = "Company name"
  type        = string
  default     = ""
}

variable "blog" {
  description = "Blog URL"
  type        = string
  default     = ""
}

variable "email" {
  description = "Organization email"
  type        = string
  default     = ""
}

variable "location" {
  description = "Organization location"
  type        = string
  default     = ""
}

variable "description" {
  description = "Organization description"
  type        = string
  default     = ""
}

variable "has_organization_projects" {
  type    = bool
  default = true
}

variable "has_repository_projects" {
  type    = bool
  default = true
}

variable "default_repository_permission" {
  type    = string
  default = "read"
}

variable "members_can_create_repositories" {
  type    = bool
  default = false
}

variable "members_can_create_public_repositories" {
  type    = bool
  default = false
}

variable "members_can_create_private_repositories" {
  type    = bool
  default = false
}

variable "members_can_create_internal_repositories" {
  type    = bool
  default = false
}

variable "members_can_create_pages" {
  type    = bool
  default = true
}

variable "members_can_fork_private_repositories" {
  type    = bool
  default = false
}

variable "web_commit_signoff_required" {
  type    = bool
  default = false
}

variable "advanced_security_enabled_for_new_repositories" {
  type    = bool
  default = false
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  type    = bool
  default = true
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  type    = bool
  default = true
}

variable "dependency_graph_enabled_for_new_repositories" {
  type    = bool
  default = true
}

variable "secret_scanning_enabled_for_new_repositories" {
  type    = bool
  default = true
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  type    = bool
  default = true
}
