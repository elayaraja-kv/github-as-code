include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/teams"
}

inputs = {
  teams = {
    "3es-sre" = {
      description = "Site Reliability Engineering team"
      privacy     = "closed"
      members = {
        "elayaraja-kv" = "maintainer"
        "elayarajakv"  = "member"
      }
    }
    "3es-admins" = {
      description = "Organization administrators"
      privacy     = "closed"
      members = {
        "elayaraja-kv" = "maintainer"
      }
    }
  }
}
