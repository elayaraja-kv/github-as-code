include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/repository"
}

locals {
  repo_name = basename(get_terragrunt_dir())
}

inputs = {
  name                   = local.repo_name
  description            = "NZ3ES Limited - Website Static repository"
  visibility             = "private"
  has_issues             = true
  has_discussions        = false
  has_projects           = true
  has_wiki               = false
  auto_init              = false
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  max_tags               = 3
}
