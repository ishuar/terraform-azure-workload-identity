variable "resource_group_name" {
  type        = string
  description = "(optional) Resource group name. If not set, the default resource group will be used."
}
variable "oidc_issuer_url" {
  description = " (Required)The URL of the OIDC issuer for the cluster"
  type        = string
}

variable "role_assignments" {
  type = set(object({
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
  default     = []
  description = <<-EOF
(optional) The role assignments for the service account.

`role_definition_name`:  The name of a role which either needs to be used (azure built-in) or new one you want to create.
`name` : A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created.
`condition`:  The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.
`condition_version`: (Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created.
`create_custom_role` : Whether or not to create a custom role. If set to true, then any of the custom_role_actions,custom_role_data_actions, custom_role_not_actions, custom_role_not_data_actions, custom_role_assignable_scopes are required.
`scope` : The scope at which the role assignment or custom role will be created.
`custom_role_definition_id`: (Optional) A unique UUID/GUID which identifies this role - one will be generated if not specified. Changing this forces a new resource to be created.Only valid for custom role.
`custom_role_actions`: One or more Allowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read. See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.
`custom_role_data_actions` : One or more Allowed Data Actions, such as *, Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read. See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.
`custom_role_not_actions` : One or more Denied Actions, such as Microsoft.Compute/virtualMachines/write.See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.
`custom_role_not_data_actions` : One or more Disallowed Data Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read
`custom_role_assignable_scopes` : One or more assignable scopes for this Role Definition. The value for scope is automatically included in this list if no other values supplied
`custom_role_description` : A description of the role. Only valid for custom role definition.
EOF
}

variable "user_assigned_identity_name" {
  type        = string
  description = "(optional) Name of User Assigned Identity to create."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the User Assigned Identity."
  default     = {}
}

variable "location" {
  type        = string
  description = "(optional) The Azure Region where the User Assigned Identity exists."
}

variable "use_existing_resource_group" {
  type        = string
  description = "(optional) Whether to use existing resource group or create a new one?"
  default     = true
}

############################################
######## Service Account variables ##########
############################################

variable "service_account_name" {
  description = "(optional) The name of the service account which is using the workload identity. Required when `create_github_actions_credential` is set to `false`. "
  type        = string
  default     = ""
}

variable "namespace" {
  description = "(optional) The namespace where service account will be created. New will be created if value is not equeal to kube-sytem and default.Required when `create_github_actions_credential` is set to `false`."
  type        = string
  default     = ""
}

variable "create_kubernetes_namespace" {
  type        = bool
  description = "(optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create_namespace' is set to false"
  default     = false
}

variable "namespace_labels" {
  type        = map(string)
  description = "(optional) Labels for namespace created via terraform-kubernetes-provider resource."
  default     = {}
}

variable "namespace_annotations" {
  type        = map(string)
  description = "(optional) Annotations for namespace created via terraform-kubernetes-provider resource."
  default     = {}
}

variable "create_service_account" {
  type        = bool
  description = "(optional) Whether or not to create kubernetes service account via terraform-kubernetes-provider? Use this if helm chart supports existing service account name."
  default     = false
}

variable "additional_service_account_annotations" {
  type        = map(string)
  description = "(optional) Additional Annotations for the new service account created."
  default     = {}
}

variable "automount_service_account_token" {
  type        = bool
  description = "(Optional) To enable automatic mounting of the service account token. Defaults to true"
  default     = false
}
variable "service_account_token_expiration_seconds" {
  type        = number
  description = "(optional) Represents the expirationSeconds field for the projected service account token"
  default     = 86400
}


############################################
######## GitHub Workflows/actions ##########
############################################
variable "github_entity_type" {
  type        = string
  description = "(optional) The filter used to scope the OIDC requests from GitHub workflows. This field is used to generate the subject claim. Accepted values are 'environment', 'branch', 'tag' or 'pull_request'. Required when `create_github_actions_credential` is set to `true`."
  default     = "pull_request"
  validation {
    condition     = var.github_entity_type == "environment" || var.github_entity_type == "branch" || var.github_entity_type == "tag" || var.github_entity_type == "pull_request"
    error_message = "Invalid entity_type. Accepted values are 'environment', 'branch', 'tag' or 'pull_request'."
  }
}

variable "github_owner" {
  type        = string
  description = "(optional) GitHub organization name or GitHub username that owns the repository where github workflow will use federated credentials. Required when `create_github_actions_credential` is set to `true`."
  default     = ""
}

variable "github_repository_name" {
  type        = string
  description = "(optional)GitHub Repository name where github workflow will use federated credentials. Required when `create_github_actions_credential` is set to `true`."
  default     = ""
}

variable "create_github_workflow_credentials" {
  type        = bool
  description = "(optional) Whether to create federated credentials for GitHub workflow or not?. Default is to to create credentials for Azure kubernetes service accounts. If set to `true`, then `github_owner`, 'github_entity_type' and `github_repository_name` must be set."
  default     = false
}

variable "environment_name" {
  type        = string
  description = "(optional) GitHub environment name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `environment`."
  default     = ""
}

variable "tag_name" {
  type        = string
  description = "(optional) GitHub tag name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `tag`."
  default     = ""
}

variable "branch_name" {
  type        = string
  description = "(optional) GitHub branch name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `branch`."
  default     = ""
}
