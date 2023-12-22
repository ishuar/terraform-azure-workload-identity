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
  subject             = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

locals {
  create_azure_built_in_role_assigments = { for k in var.role_assignments : format("%s-%s", var.service_account_name, k.role_definition_name) => k if k.create_custom_role != true }
  create_custom_role_assigments         = { for k in var.role_assignments : format("%s-%s", var.service_account_name, k.role_definition_name) => k if k.create_custom_role == true }
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
