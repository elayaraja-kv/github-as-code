locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("_env.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  gcp_project  = local.common_vars.locals.gcp_project
  gcp_location = local.common_vars.locals.gcp_location
  github_owner = local.env_vars.locals.github_owner
}

remote_state {
  backend = "gcs"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket   = "nz3es-tf-state-iac"
    prefix   = "github-as-code/${path_relative_to_include()}"
    project  = local.gcp_project
    location = local.gcp_location
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<-EOF
    terraform {
      required_version = ">= 1.5"

      required_providers {
        github = {
          source  = "integrations/github"
          version = "~> 6.0"
        }
        google = {
          source  = "hashicorp/google"
          version = "~> 6.0"
        }
      }
    }

    provider "github" {
      token = var.github_token
      owner = "${local.github_owner}"
    }

    provider "google" {
      project = "${local.gcp_project}"
      region  = "${local.gcp_location}"
    }
  EOF
}

inputs = {
  github_owner = local.github_owner
}
