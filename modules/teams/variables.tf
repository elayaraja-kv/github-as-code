variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "teams" {
  description = <<-EOT
    Map of teams to manage. Key is team name. Value supports:
    - description: string
    - privacy: "closed" or "secret"
    - parent_team_id: number (optional)
    - members: map of username => role ("member" or "maintainer")
    - repositories: map of repo_name => permission ("pull", "push", "admin", "maintain", "triage")
  EOT
  type        = map(any)
  default     = {}
}
