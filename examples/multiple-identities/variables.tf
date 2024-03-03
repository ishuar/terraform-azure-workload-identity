## For creating multiple identities using single variable
## you can use the following variable definition for all features.
## this is not being used in the example, but it is here for reference.
variable "identities" {
  type = set(object({
    service_account_name               = string
    namespace                          = string
    oidc_issuer_url                    = string
    create_github_workflow_credentials = bool
    github_owner                       = string ## required if create_github_workflow_credentials is true
    github_repository_name             = string ## required if create_github_workflow_credentials is true
    github_entity_type                 = string ## required if create_github_workflow_credentials is true
    role_assignments = set(object({
      role_definition_name          = optional(string)
      name                          = optional(string, null)
      create_custom_role            = optional(bool, false)
      condition                     = optional(string, null)
      condition_version             = optional(string, null)
      scope                         = optional(string)
      custom_role_description       = optional(string)
      custom_role_definition_id     = optional(string, null)
      custom_role_actions           = optional(set(string), [])
      custom_role_data_actions      = optional(set(string), [])
      custom_role_not_actions       = optional(set(string), [])
      custom_role_not_data_actions  = optional(set(string), [])
      custom_role_assignable_scopes = optional(set(string), null)
    }))
  }))
  description = "(optional) Identities to create. See README for more information.It includes all the inputs from the role_assignments block in the module."
  default = [
    # ########### Identity with Azure built-in role ###########
    # {
    #   service_account_name = "example-service-account-01"
    #   namespace            = "example-01"
    #   role_assignments = [
    #     {
    #       role_definition_name = "Reader"
    #       scope                = <scope-where-the-role-should-be-assigned>
    #     },
    #   ]
    # },
    # ########### Identity with Azure built-in and custom role ###########
    # {
    #   service_account_name = "example-service-account-02"
    #   namespace            = "example-02"
    #   create_custom_role   = true
    #   role_assignments = [
    #     {
    #       role_definition_name = "Reader"
    #       scope                = <scope-where-the-role-should-be-assigned>
    #     },
    #     {
    #       role_definition_name = "blob-reader"
    #       scope                = <scope-where-the-role-should-be-assigned>
    #       create_custom_role   = true
    #       custom_role_data_actions = [
    #         "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
    #       ]
    #     }
    #   ]
    # },
    # {
    #   create_github_workflow_credentials = true
    #   github_owner                       = "ishuar"
    #   github_repository_name             = "terraform-azure-workload-identity"
    #   github_entity_type                 = "pull_request"
    #   oidc_issuer_url                    = "https://token.actions.githubusercontent.com"
    #   role_assignments = [
    #     ############## Azure built-in role ###############
    #     {
    #       role_definition_name = "Contributor"
    #       scope                = azurerm_resource_group.this.id
    #     },
    #   ]
    # }
  ]
}

##### Testing #####
# Path: ../../tests/multiple-identities.auto.tfvars
###################

variable "service_account_name" {
  type        = string
  description = "(optional) Service Account name for second example, need variable to over-ride in tests."
  default     = "example-service-account-02"
}
variable "namespace" {
  type        = string
  description = "(optional) namesapce for example-service-account-02, need variable to over-ride in tests."
  default     = "default"
}
