resource "ibm_cd_toolchain_tool_githubconsolidated" "app_repo" {
  toolchain_id = var.toolchain_id
  name         = "repo"
  initialization {
    owner_id = var.app_repo_github_user
    git_id = "github"
    type = "link"
    repo_url = var.app_repo
    auto_init = false
  }  
  parameters {
    toolchain_issues_enabled = false
    enable_traceability = false
    integration_owner = var.app_repo_user_id
    auth_type = "pat"
    api_token = var.app_repo_auth_token
  }
}

resource "ibm_cd_toolchain_tool_githubconsolidated" "tekton_tasks_catalog_repo" {
  toolchain_id = var.toolchain_id
  name         = "tasks-repo"
  initialization {
    owner_id = var.tekton_tasks_catalog_repo_github_user
    git_id = "github"
    type = "link"
    repo_url = var.tekton_tasks_catalog_repo
    auto_init = false
  }
  parameters {
    integration_owner = var.tekton_tasks_catalog_repo_user_id
    toolchain_issues_enabled = false
    enable_traceability = false
    auth_type = "pat"
    api_token = var.tekton_tasks_catalog_repo_auth_token
  }
}

output "app_repo_url" {
  value = ibm_cd_toolchain_tool_githubconsolidated.app_repo.parameters[0].repo_url
}

output "tekton_tasks_catalog_repo_url" {
  value = ibm_cd_toolchain_tool_githubconsolidated.tekton_tasks_catalog_repo.parameters[0].repo_url
}