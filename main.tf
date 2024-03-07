## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/data-sources/client_config
data "azurerm_client_config" "current" {}

## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "this" {
  name                = "${local.uid_name}-uid"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/resources/federated_identity_credential
resource "azurerm_federated_identity_credential" "this" {
  name                = "${azurerm_user_assigned_identity.this.name}-fed-creds"
  resource_group_name = azurerm_user_assigned_identity.this.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = local.subject

  lifecycle {
    precondition {
      condition     = var.create_github_workflow_credentials || var.namespace != ""
      error_message = "`namespace` must be set when `create_github_workflow_credentials` is set to `false`"
    }
    precondition {
      condition     = var.create_github_workflow_credentials || var.service_account_name != ""
      error_message = "`service_account_name` must be set when `create_github_workflow_credentials` is set to `false`"
    }
    precondition {
      condition     = !var.create_github_workflow_credentials || var.github_entity_type != ""
      error_message = "`github_entity_type` must be set when `create_github_workflow_credentials` is set to `true`"
    }
    precondition {
      condition     = !var.create_github_workflow_credentials || var.github_owner != ""
      error_message = "`github_owner` must be set when `create_github_workflow_credentials` is set to `true`"
    }
    precondition {
      condition     = !var.create_github_workflow_credentials || var.github_repository_name != ""
      error_message = "`github_repository_name` must be set when `create_github_workflow_credentials` is set to `true`"
    }
    precondition {
      condition     = var.github_entity_type != "environment" || (var.github_entity_type == "environment" && var.github_environment_name != "")
      error_message = "`github_environment_name` must be set when `github_entity_type` is set to `environment`"
    }
    precondition {
      condition     = var.github_entity_type != "branch" || (var.github_entity_type == "branch" && var.github_branch_name != "")
      error_message = "`github_branch_name` must be set when `github_entity_type` is set to `branch`"
    }
    precondition {
      condition     = var.github_entity_type != "tag" || (var.github_entity_type == "tag" && var.github_tag_name != "")
      error_message = "`github_tag_name` must be set when `github_entity_type` is set to `tag`"
    }

  }
}

locals {
  ## module.simple.azurerm_role_assignment.custom["key_for_resource_reference"]
  ## module.simple.azurerm_role_assignment.azure["-key_for_resource_reference"]
  key_for_resource_azurerm_role_assignment = var.create_github_workflow_credentials ? format("gh-repo-%s", var.github_repository_name) : var.service_account_name ## ref above ##
  create_azure_built_in_role_assigments    = { for k in var.role_assignments : format("%s-%s", local.key_for_resource_azurerm_role_assignment, k.role_definition_name) => k if k.create_custom_role != true }
  create_custom_role_assigments            = { for k in var.role_assignments : format("%s-%s", local.key_for_resource_azurerm_role_assignment, k.role_definition_name) => k if k.create_custom_role == true }
}

## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/resources/role_assignment
resource "azurerm_role_assignment" "azure" {
  for_each             = length(var.role_assignments) > 0 ? local.create_azure_built_in_role_assigments : {}
  name                 = each.value.name
  condition            = each.value.condition
  condition_version    = each.value.condition_version
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/resources/role_definition
resource "azurerm_role_definition" "this" {
  for_each = length(var.role_assignments) > 0 ? local.create_custom_role_assigments : {}

  name               = each.value.role_definition_name
  scope              = each.value.scope
  description        = each.value.custom_role_description
  role_definition_id = each.value.custom_role_definition_id
  assignable_scopes  = each.value.custom_role_assignable_scopes
  permissions {
    actions          = each.value.custom_role_actions
    data_actions     = each.value.custom_role_data_actions
    not_actions      = each.value.custom_role_not_actions
    not_data_actions = each.value.custom_role_not_data_actions
  }
}

## ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.85.0/docs/resources/role_assignment
resource "azurerm_role_assignment" "custom" {
  for_each = length(var.role_assignments) > 0 ? local.create_custom_role_assigments : {}

  scope                = azurerm_role_definition.this[each.key].scope
  name                 = each.value.name
  role_definition_name = azurerm_role_definition.this[each.key].name
  condition            = each.value.condition
  condition_version    = each.value.condition_version
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
