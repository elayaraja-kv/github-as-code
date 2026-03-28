variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub user or organization"
  type        = string
}

# ─── Lifecycle ──────────────────────────────────────────────────────────────

variable "prevent_destroy" {
  description = <<-EOT
    Prevent accidental deletion of this repository via Terraform.
    To switch an existing repo from true → false, first run:
      terraform state mv 'github_repository.this[0]' 'github_repository.unprotected[0]'
  EOT
  type    = bool
  default = true
}

# ─── Repository settings ────────────────────────────────────────────────────

variable "name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility: public, private, or internal"
  type        = string
  default     = "private"
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_discussions" {
  type    = bool
  default = false
}

variable "has_projects" {
  type    = bool
  default = true
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "allow_merge_commit" {
  type    = bool
  default = true
}

variable "allow_squash_merge" {
  type    = bool
  default = true
}

variable "allow_rebase_merge" {
  type    = bool
  default = true
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}

variable "pages" {
  description = "GitHub Pages config. Set to null to disable."
  type = object({
    branch = string
    path   = optional(string, "/")
  })
  default = null
}

# ─── Branch protection ──────────────────────────────────────────────────────

variable "branch_protections" {
  description = <<-EOT
    Map of branch patterns to protect. Key is the branch pattern (e.g. "main"). Value supports:
    - enforce_admins: bool (default true)
    - allows_deletions: bool (default false)
    - allows_force_pushes: bool (default false)
    - required_reviews: object with approving_count, dismiss_stale, require_code_owners
    - required_status_checks: object with strict, contexts
  EOT
  type    = map(any)
  default = {}
}

# ─── Webhooks ───────────────────────────────────────────────────────────────

variable "webhooks" {
  description = <<-EOT
    Map of webhooks. Key is a unique identifier. Value:
    - url: string (webhook URL)
    - content_type: string ("json" or "form", default "json")
    - insecure_ssl: bool (default false)
    - secret: string (optional shared secret)
    - active: bool (default true)
    - events: list of event names (e.g. ["push", "pull_request"])
  EOT
  type    = map(any)
  default = {}
}

# ─── Repository-level secrets ───────────────────────────────────────────────

variable "secrets" {
  description = "Map of secret_name => secret_value for repo-level Actions secrets"
  type        = map(string)
  default     = {}
}

# ─── Tag retention ──────────────────────────────────────────────────────────

variable "max_tags" {
  description = "Maximum number of tags to retain (sorted by creation date, oldest deleted first). Set to null to disable cleanup."
  type        = number
  default     = null
}
