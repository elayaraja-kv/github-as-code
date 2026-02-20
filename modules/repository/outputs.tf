output "repository_url" {
  description = "HTML URL of the repository"
  value       = local.repo.html_url
}

output "repository_id" {
  description = "Node ID of the repository (for branch protection)"
  value       = local.repo.node_id
}

output "repository_name" {
  description = "Name of the repository"
  value       = local.repo.name
}

output "repo_id" {
  description = "Numeric ID of the repository"
  value       = local.repo.repo_id
}
