output "org_secret_names" {
  description = "List of org-level secret names"
  value       = keys(github_actions_organization_secret.this)
}
