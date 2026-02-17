resource "github_actions_organization_permissions" "this" {
  count = var.org_permissions != null ? 1 : 0

  allowed_actions      = lookup(var.org_permissions, "allowed_actions", "selected")
  enabled_repositories = lookup(var.org_permissions, "enabled_repositories", "all")

  dynamic "allowed_actions_config" {
    for_each = lookup(var.org_permissions, "allowed_actions", "selected") == "selected" ? [1] : []
    content {
      github_owned_allowed = lookup(var.org_permissions, "github_owned_allowed", true)
      patterns_allowed     = lookup(var.org_permissions, "patterns_allowed", [])
      verified_allowed     = lookup(var.org_permissions, "verified_allowed", true)
    }
  }
}

resource "github_actions_repository_permissions" "this" {
  for_each = var.repo_permissions

  repository      = each.key
  allowed_actions = lookup(each.value, "allowed_actions", "selected")
  enabled         = lookup(each.value, "enabled", true)

  dynamic "allowed_actions_config" {
    for_each = lookup(each.value, "allowed_actions", "selected") == "selected" ? [1] : []
    content {
      github_owned_allowed = lookup(each.value, "github_owned_allowed", true)
      patterns_allowed     = lookup(each.value, "patterns_allowed", [])
      verified_allowed     = lookup(each.value, "verified_allowed", true)
    }
  }
}
