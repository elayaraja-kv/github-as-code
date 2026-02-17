# GitHub As Code

Manage GitHub resources using **Terragrunt** + Terraform. Each repository gets its own folder with isolated state, including repo-level resources (branch protections, webhooks, secrets). Org-level resources (teams, org settings, Actions permissions, org secrets) are managed separately.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) >= 0.68
- A **GCS bucket** for remote state storage (configured in `root.hcl`)
- A **GitHub Personal Access Token** with scopes: `admin:org`, `repo`, `delete_repo`
- GCP credentials with access to the state bucket

## Quick Start

1. **Configure shared settings** — edit `environments/_env.hcl` with your GCP project ID and location.

2. **Configure environments** — edit `environments/personal/env.hcl` and `environments/org/env.hcl` with your GitHub username/org name.

3. **Export secrets:**

   ```bash
   export TF_VAR_github_token="ghp_xxxxxxxxxxxx"
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
   ```

4. **Plan all environments:**

   ```bash
   cd environments
   terragrunt run-all plan
   ```

5. **Plan a single repo:**

   ```bash
   cd environments/personal/repositories/infra-as-code
   terragrunt plan
   ```

6. **Apply:**

   ```bash
   cd environments
   terragrunt run-all apply
   ```

## Adding a New Repository

Each repository gets its own folder and isolated state file.

1. Create a folder under `environments/<env>/repositories/<repo-name>/`
2. Add a `terragrunt.hcl`:

   ```hcl
   include "root" {
     path = find_in_parent_folders("root.hcl")
   }

   terraform {
     source = "${get_repo_root()}/modules/repository"
   }

   locals {
     repo_name = basename(get_terragrunt_dir())
   }

   inputs = {
     name        = local.repo_name
     description = "Managed by Terragrunt"
     visibility  = "private"

     # Branch protection requires GitHub Pro/Team for private repos.
     # Omit this block for private repos on free plans.
     branch_protections = {
       "main" = {
         enforce_admins = true
         required_reviews = {
           approving_count = 0
         }
       }
     }
   }
   ```

3. Run `terragrunt plan` from the new folder.

## Common Operations

### Import an existing repository

```bash
# 1. Create the folder and terragrunt.hcl (as above)
mkdir -p environments/personal/repositories/my-existing-repo

# 2. Add terragrunt.hcl with settings matching the existing repo

# 3. Import into state
cd environments/personal/repositories/my-existing-repo
terragrunt import 'github_repository.this' my-existing-repo

# 4. Verify no drift
terragrunt plan
```

### Plan/apply a single repo

```bash
cd environments/personal/repositories/infra-as-code
terragrunt plan
terragrunt apply
```

### Plan/apply all repos under one environment

```bash
cd environments/personal/repositories
terragrunt run-all plan
terragrunt run-all apply
```

### Plan/apply everything (all environments, all resource types)

```bash
cd environments
terragrunt run-all plan
terragrunt run-all apply
```

### Destroy a single repo (removes from GitHub)

```bash
cd environments/personal/repositories/my-repo
terragrunt destroy
```

### Remove a repo from Terraform without deleting it on GitHub

```bash
cd environments/personal/repositories/my-repo
terragrunt state rm 'github_repository.this'
# Then delete the folder
```

### View current state for a repo

```bash
cd environments/personal/repositories/infra-as-code
terragrunt state list
terragrunt state show 'github_repository.this'
```

## Resource Types

### Personal account (`environments/personal/`)

| Unit                          | What it manages                                                    |
| ----------------------------- | ------------------------------------------------------------------ |
| `repositories/<repo-name>/`   | Repo settings, branch protections, webhooks, secrets (per folder)  |

### Organization (`environments/org/`)

| Unit                          | What it manages                                                    |
| ----------------------------- | ------------------------------------------------------------------ |
| `repositories/<repo-name>/`   | Repo settings, branch protections, webhooks, secrets (per folder)  |
| `teams/`                      | Org teams, memberships, repo access                                |
| `org-settings/`               | Org-level settings and policies                                    |
| `actions/`                    | Actions permissions (org-level)                                    |
| `secrets/`                    | Org-level Actions secrets                                          |

## Shared Modules

Reusable Terraform modules live in `modules/`. Each environment unit references these via `terraform.source` in its `terragrunt.hcl`.

| Module         | Resources                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------- |
| `repository`   | `github_repository`, `github_branch_protection`, `github_repository_webhook`, `github_actions_secret` |
| `teams`        | `github_team`, `github_team_membership`                                                               |
| `org-settings` | `github_organization_settings`                                                                        |
| `actions`      | `github_actions_*_permissions`                                                                        |
| `org-secrets`  | `github_actions_organization_secret`                                                                  |

## CI/CD

GitHub Actions workflow (`.github/workflows/terragrunt.yml`) automates:

- **On PR:** runs `terragrunt run-all plan` and posts the output as a PR comment
- **On merge to main:** runs `terragrunt run-all apply` automatically

### Required GitHub Secrets

| Secret               | Description                                          |
| -------------------- | ---------------------------------------------------- |
| `GH_TOKEN`           | GitHub PAT with the scopes listed above              |
| `GOOGLE_CREDENTIALS` | GCP service account JSON key (for GCS state backend) |

## Project Structure

```text
├── root.hcl                              # Root config: GCS backend, provider generation
├── modules/                              # Shared Terraform modules
│   ├── repository/                       # Repo + branch protection + webhooks + secrets
│   ├── teams/
│   ├── org-settings/
│   ├── actions/
│   └── org-secrets/
├── environments/
│   ├── _env.hcl                          # Shared config (GCP project, location, defaults)
│   ├── personal/
│   │   ├── env.hcl                       # Personal account config
│   │   └── repositories/
│   │       └── infra-as-code/terragrunt.hcl
│   └── org/
│       ├── env.hcl                       # Org account config
│       ├── repositories/
│       │   └── 3es-website-dynamic/terragrunt.hcl
│       ├── teams/terragrunt.hcl
│       ├── org-settings/terragrunt.hcl
│       ├── actions/terragrunt.hcl
│       └── secrets/terragrunt.hcl
└── .github/workflows/
    └── terragrunt.yml                    # CI/CD pipeline
```

Each repo gets its own isolated Terraform state in GCS at `github-as-code/{env}/repositories/{repo-name}/terraform.tfstate`.
