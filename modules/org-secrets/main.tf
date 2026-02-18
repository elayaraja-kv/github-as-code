data "google_secret_manager_secret_version" "this" {
  count   = var.gcp_secrets_name != null ? 1 : 0
  project = var.gcp_project
  secret  = var.gcp_secrets_name
}

locals {
  secrets = var.gcp_secrets_name != null ? jsondecode(data.google_secret_manager_secret_version.this[0].secret_data) : {}
}

resource "github_actions_organization_secret" "this" {
  for_each = nonsensitive(toset(keys(local.secrets)))

  secret_name     = each.key
  visibility      = lookup(lookup(var.org_secrets, each.key, {}), "visibility", "all")
  plaintext_value = local.secrets[each.key]
}

resource "github_actions_organization_secret_repositories" "this" {
  for_each = {
    for k, v in var.org_secrets : k => v
    if lookup(v, "selected_repository_ids", null) != null
  }

  secret_name             = github_actions_organization_secret.this[each.key].secret_name
  selected_repository_ids = each.value.selected_repository_ids
}
