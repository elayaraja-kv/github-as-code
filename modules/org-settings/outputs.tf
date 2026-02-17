output "organization_id" {
  description = "The ID of the organization"
  value       = github_organization_settings.this.id
}

output "company" {
  description = "The company name of the organization"
  value       = github_organization_settings.this.company
}
