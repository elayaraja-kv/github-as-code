include "root" {
  path = find_in_parent_folders("root.hcl")
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
  org_secrets = {
    # "ORG_DEPLOY_TOKEN" = {
    #   value      = get_env("TF_VAR_org_deploy_token", "")
    #   visibility = "selected"
    #   selected_repository_ids = [
    #     dependency.my_repo.outputs.repo_id,
    #   ]
    # }
  }
}
