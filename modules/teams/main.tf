resource "github_team" "this" {
  for_each = var.teams

  name        = each.key
  description = lookup(each.value, "description", "")
  privacy     = lookup(each.value, "privacy", "closed")
  parent_team_id = lookup(each.value, "parent_team_id", null)
}

locals {
  team_memberships = merge([
    for team_name, team_config in var.teams : {
      for username, role in lookup(team_config, "members", {}) :
      "${team_name}-${username}" => {
        team_name = team_name
        username  = username
        role      = role
      }
    }
  ]...)

  team_repos = merge([
    for team_name, team_config in var.teams : {
      for repo, permission in lookup(team_config, "repositories", {}) :
      "${team_name}-${repo}" => {
        team_name  = team_name
        repository = repo
        permission = permission
      }
    }
  ]...)
}

resource "github_team_membership" "this" {
  for_each = local.team_memberships

  team_id  = github_team.this[each.value.team_name].id
  username = each.value.username
  role     = each.value.role
}

resource "github_team_repository" "this" {
  for_each = local.team_repos

  team_id    = github_team.this[each.value.team_name].id
  repository = each.value.repository
  permission = each.value.permission
}
