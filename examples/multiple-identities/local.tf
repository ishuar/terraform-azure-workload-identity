locals {
  prefix = "wi-multi-module"

  tags = {
    github_repo = "ishuar/terraform-azure-workload-identity"
    managed_by  = "terraform"
    used_case   = "tf-az-wi-module-dev"
  }

  example-service-account-01 = [
    ########### Identity with Azure built-in role ###########
    {
      service_account_name = "example-service-account-01"
      namespace            = "example-01"
      oidc_issuer_url      = "https://token.actions.githubusercontent.com" ## only exampke should be AKS OIDC issuer URL
      role_assignments = [
        {
          role_definition_name = "Reader"
          scope                = azurerm_resource_group.this.id
        },
      ]
    },
  ]
  example-service-account-02 = [
    ########### Identity with Azure built-in and custom role ###########
    {
      service_account_name = var.service_account_name                      # for testing purposes
      namespace            = var.namespace                                 # for testing purposes
      oidc_issuer_url      = "https://token.actions.githubusercontent.com" ## only exampke should be AKS OIDC issuer URL
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
  ########### Identity with GitHub Workflow/Actions ###########
  github-workflow-identities = [
    {
      create_github_workflow_credentials = true
      github_owner                       = "ishuar"
      github_repository_name             = "terraform-azure-workload-identity"
      github_entity_type                 = "pull_request"
      oidc_issuer_url                    = "https://token.actions.githubusercontent.com"
      role_assignments = [
        ############## Azure built-in role ###############
        {
          role_definition_name = "Contributor"
          scope                = azurerm_resource_group.this.id
        },
      ]
    }
  ]

  service_account_identities = concat(
    local.example-service-account-01,
    local.example-service-account-02
  )

  all_identities = concat(
    local.example-service-account-01,
    local.example-service-account-02,
    local.github-workflow-identities
  )
}
