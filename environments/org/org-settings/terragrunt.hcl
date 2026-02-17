include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/org-settings"
}

inputs = {
  name          = "3es"
  billing_email = "elayaraja.kv@3es.nz"
  company       = "NZ3ES Limited"
  location      = "New Zealand"
  description   = "NZ3ES Limited"

  default_repository_permission         = "read"
  members_can_create_repositories       = false
  members_can_create_pages              = true
  members_can_fork_private_repositories = false

  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}
