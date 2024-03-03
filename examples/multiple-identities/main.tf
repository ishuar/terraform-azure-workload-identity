resource "azurerm_resource_group" "this" {
  location = "North Europe"
  name     = "${local.prefix}-resources"
}
/*

### Multiple Identities using for_each on the module level ###

module "multiple_service_account_identities" {
  ## check variables.tf for variable definition
  for_each = { for identity in local.service_account_identities : identity.service_account_name => identity }

  source               = "../../"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  oidc_issuer_url      = "<AKS_OIDC_ISSUER_URL>" # -> data.azurerm_kubernetes_cluster.example.oidc_issuer_url
  service_account_name = each.value.service_account_name
  namespace            = each.value.namespace
  role_assignments     = each.value.role_assignments
}

### Multiple GitHub Workflow Identities using for_each on the module level with differnt interface ###

module "multiple_github_workflow_identities" {
  ## check variables.tf for variable definition
  for_each = { for identity in local.github-workflow-identities : identity.github_repository_name => identity }
  source   = "../../"

  resource_group_name                = azurerm_resource_group.this.name
  location                           = azurerm_resource_group.this.location
  oidc_issuer_url                    = "https://token.actions.githubusercontent.com"
  role_assignments                   = each.value.role_assignments
  create_github_workflow_credentials = true
  github_owner                       = each.value.github_owner
  github_repository_name             = each.value.github_repository_name
  github_entity_type                 = each.value.github_entity_type

}

*/


### Combination of GitHub workflow and Kubernetes Service Account multiple Identities using for_each on the module level with single interface ###
module "combination_service_accounts_and_github_workflow_identities" {
  ## check variables.tf for variable definition
  for_each = { for identity in local.all_identities : try(identity.service_account_name, identity.github_repository_name) => identity }
  source   = "../../"

  #### COMMON CONFIGURATION ####
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  oidc_issuer_url     = each.value.oidc_issuer_url
  role_assignments    = each.value.role_assignments

  #### KUBERNETES SERVICE ACCOUNT CONFIGURATION ####
  service_account_name = try(each.value.service_account_name, "")
  namespace            = try(each.value.namespace, "")

  #### GITHUB WORKFLOW/ACTIONS CONFIGURATION ####
  create_github_workflow_credentials = try(each.value.create_github_workflow_credentials, false)
  github_owner                       = try(each.value.github_owner, "")
  github_repository_name             = try(each.value.github_repository_name, "")
  github_entity_type                 = "pull_request"

}
