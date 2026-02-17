output "org_permissions_id" {
  description = "ID of the org-level Actions permissions"
  value       = length(github_actions_organization_permissions.this) > 0 ? github_actions_organization_permissions.this[0].id : null
}
