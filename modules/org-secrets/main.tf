resource "github_actions_organization_secret" "this" {
  for_each = var.org_secrets

  secret_name     = each.key
  visibility      = lookup(each.value, "visibility", "selected")
  plaintext_value = each.value.value
}

resource "github_actions_organization_secret_repositories" "this" {
  for_each = {
    for k, v in var.org_secrets : k => v
    if lookup(v, "selected_repository_ids", null) != null
  }

  secret_name             = github_actions_organization_secret.this[each.key].secret_name
  selected_repository_ids = each.value.selected_repository_ids
}
