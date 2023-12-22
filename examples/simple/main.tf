resource "azurerm_resource_group" "this" {
  location = "North Europe"
  name     = "${local.prefix}-resources"
}

module "simple" {
  source               = "../../"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  oidc_issuer_url      = "https://token.actions.githubusercontent.com"
  service_account_name = "${local.prefix}-service-account"
  namespace            = "default"
  role_assignments = [
    ############## Azure built-in role ###############
    {
      role_definition_name = "Reader"
      scope                = azurerm_resource_group.this.id
    },
    ############## Azure custom role ###############
    {
      role_definition_name = "blob-reader"
      create_custom_role   = true
      scope                = azurerm_resource_group.this.id
      custom_role_data_actions = [
        "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      ]
    }
  ]
}
