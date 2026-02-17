resource "github_actions_organization_secret" "this" {
  for_each = var.org_secrets

  secret_name     = each.key
  visibility      = lookup(each.value, "visibility", "selected")
  plaintext_value = each.value.value

  selected_repository_ids = lookup(each.value, "selected_repository_ids", null)
}
