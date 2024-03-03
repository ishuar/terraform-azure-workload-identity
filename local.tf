locals {
  uid_with_service_account_name = var.service_account_name != "" ? var.service_account_name : format("gh-repo-%s", var.github_repository_name)
  uid_name                      = var.user_assigned_identity_name != "" ? var.user_assigned_identity_name : local.uid_with_service_account_name

  ## Multiple filters using conditional expressions for github workflows/actions subject name.
  tag_entity_type         = var.github_entity_type != "tag" ? "" : "ref:refs/tags/${var.tag_name}"
  branch_entity_type      = var.github_entity_type != "branch" ? (local.tag_entity_type) : "ref:refs/heads/${var.branch_name}"
  environment_entity_type = var.github_entity_type != "environment" ? (local.branch_entity_type) : "environment/${var.environment_name}"
  github_entity_config    = var.github_entity_type != "pull_request" ? (local.environment_entity_type) : "pull_request"

  ## final subject name contstructed using the entity_config.
  github_workflow_subject_name = format("repo:%s/%s:%s",
    var.github_owner,
    var.github_repository_name,
    local.github_entity_config
  )

  kubernetes_service_account_subject = format("system:serviceaccount:%s:%s", var.namespace, var.service_account_name)
  subject                            = !var.create_github_workflow_credentials ? local.kubernetes_service_account_subject : local.github_workflow_subject_name
}
