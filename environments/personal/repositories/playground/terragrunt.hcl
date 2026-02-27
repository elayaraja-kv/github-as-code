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
  description            = "Personal playground for experimenting with various technologies (Valkey, Kafka, Postgres, etc.)"
  visibility             = "public"
  has_issues             = true
  has_discussions        = false
  has_projects           = false
  has_wiki               = false
  auto_init              = true
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true

  branch_protections = {}
}
