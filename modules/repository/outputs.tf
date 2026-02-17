output "repository_url" {
  description = "HTML URL of the repository"
  value       = github_repository.this.html_url
}

output "repository_id" {
  description = "Node ID of the repository (for branch protection)"
  value       = github_repository.this.node_id
}

output "repository_name" {
  description = "Name of the repository"
  value       = github_repository.this.name
}

output "repo_id" {
  description = "Numeric ID of the repository"
  value       = github_repository.this.repo_id
}
