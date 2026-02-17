include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/actions"
}

inputs = {
  # org_permissions = {
  #   allowed_actions      = "selected"
  #   enabled_repositories = "all"
  #   github_owned_allowed = true
  #   patterns_allowed     = ["hashicorp/*", "actions/*"]
  #   verified_allowed     = true
  # }

  repo_permissions = {
    # "org-project" = {
    #   allowed_actions      = "selected"
    #   enabled              = true
    #   github_owned_allowed = true
    #   patterns_allowed     = ["hashicorp/*"]
    #   verified_allowed     = true
    # }
  }
}
