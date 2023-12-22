resource "azurerm_resource_group" "this" {
  location = "North Europe"
  name     = "${local.prefix}-resources"
}

### Multiple Identities using for_each on the module level ###

module "multiple_identities" {
  ## check variables.tf for variable definition
  for_each = { for identity in local.identities : identity.service_account_name => identity }

  source               = "../../"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  oidc_issuer_url      = "https://token.actions.githubusercontent.com"
  service_account_name = each.value.service_account_name
  namespace            = each.value.namespace
  role_assignments     = each.value.role_assignments
}
