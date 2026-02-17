output "team_ids" {
  description = "Map of team names to their IDs"
  value       = { for name, team in github_team.this : name => team.id }
}

output "team_slugs" {
  description = "Map of team names to their slugs"
  value       = { for name, team in github_team.this : name => team.slug }
}
