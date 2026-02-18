include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("_env.hcl"))
}

terraform {
  source = "${get_repo_root()}/modules/org-secrets"
}

# Add a dependency block for each repo that needs org secret access.
# Example:
# dependency "my_repo" {
#   config_path = "../repositories/my-repo"
#
#   mock_outputs = {
#     repo_id = 0
#   }
# }

inputs = {
  gcp_project      = local.common_vars.locals.gcp_project
  gcp_secrets_name = "github-org-secrets-ause2" # GCP SM secret containing JSON: {"SECRET_NAME": "value", ...}

  # Optional: override visibility or restrict to specific repos per secret.
  # org_secrets = {
  #   "ORG_DEPLOY_TOKEN" = {
  #     visibility = "selected"
  #     selected_repository_ids = [
  #       dependency.my_repo.outputs.repo_id,
  #     ]
  #   }
  # }
}
