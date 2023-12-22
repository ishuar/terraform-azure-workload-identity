locals {
  prefix = "wi-multi-module"

  tags = {
    github_repo = "ishuar/terraform-azure-workload-identity"
    managed_by  = "terraform"
    used_case   = "tf-az-wi-module-dev"
  }

  identities = [
    ########### Identity with Azure built-in role ###########
    {
      service_account_name = "example-service-account-01"
      namespace            = "example-01"
      role_assignments = [
        {
          role_definition_name = "Reader"
          scope                = azurerm_resource_group.this.id
        },
      ]
    },
    ########### Identity with Azure built-in and custom role ###########
    {
      service_account_name = "example-service-account-02"
      namespace            = "example-02"
      create_custom_role   = true
      role_assignments = [
        {
          role_definition_name = "Reader"
          scope                = azurerm_resource_group.this.id
        },
        {
          role_definition_name = "blob-reader"
          scope                = azurerm_resource_group.this.id
          create_custom_role   = true
          custom_role_data_actions = [
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
          ]
        }
      ]
    }
  ]
}
