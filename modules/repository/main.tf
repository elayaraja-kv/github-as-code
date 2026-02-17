resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  has_issues       = var.has_issues
  has_discussions   = var.has_discussions
  has_projects      = var.has_projects
  has_wiki          = var.has_wiki

  auto_init              = var.auto_init
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  vulnerability_alerts = var.vulnerability_alerts

  dynamic "pages" {
    for_each = var.pages != null ? [var.pages] : []
    content {
      source {
        branch = pages.value.branch
        path   = lookup(pages.value, "path", "/")
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# ─── Branch protection ───────────────────────────────────────────────────────

resource "github_branch_protection" "this" {
  for_each = var.branch_protections

  repository_id = github_repository.this.node_id
  pattern       = each.key

  enforce_admins      = lookup(each.value, "enforce_admins", true)
  allows_deletions    = lookup(each.value, "allows_deletions", false)
  allows_force_pushes = lookup(each.value, "allows_force_pushes", false)

  dynamic "required_pull_request_reviews" {
    for_each = lookup(each.value, "required_reviews", null) != null ? [each.value.required_reviews] : []
    content {
      required_approving_review_count = lookup(required_pull_request_reviews.value, "approving_count", 0)
      dismiss_stale_reviews           = lookup(required_pull_request_reviews.value, "dismiss_stale", true)
      require_code_owner_reviews      = lookup(required_pull_request_reviews.value, "require_code_owners", false)
    }
  }

  dynamic "required_status_checks" {
    for_each = lookup(each.value, "required_status_checks", null) != null ? [each.value.required_status_checks] : []
    content {
      strict   = lookup(required_status_checks.value, "strict", true)
      contexts = lookup(required_status_checks.value, "contexts", [])
    }
  }
}

# ─── Repository webhooks ────────────────────────────────────────────────────

resource "github_repository_webhook" "this" {
  for_each = var.webhooks

  repository = github_repository.this.name

  configuration {
    url          = each.value.url
    content_type = lookup(each.value, "content_type", "json")
    insecure_ssl = lookup(each.value, "insecure_ssl", false)
    secret       = lookup(each.value, "secret", null)
  }

  active = lookup(each.value, "active", true)
  events = each.value.events
}

# ─── Repository-level Actions secrets ───────────────────────────────────────

resource "github_actions_secret" "this" {
  for_each = var.secrets

  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value
}
