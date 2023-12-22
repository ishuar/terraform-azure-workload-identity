# Introduction

This example show the example of using the module to create a multiple user-managed identities and assign a combination of azure built-in and newly created custom role definitions via module.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_multiple_identities"></a> [multiple\_identities](#module\_multiple\_identities) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identities"></a> [identities](#input\_identities) | (optional) Identities to create. See README for more information.It includes all the inputs from the role\_assignments block in the module. | <pre>set(object({<br>    service_account_name = string<br>    namespace            = string<br>    role_assignments = set(object({<br>      role_definition_name          = optional(string)<br>      name                          = optional(string, null)<br>      create_custom_role            = optional(bool, false)<br>      condition                     = optional(string, null)<br>      condition_version             = optional(string, null)<br>      scope                         = optional(string)<br>      custom_role_description       = optional(string)<br>      custom_role_definition_id     = optional(string, null)<br>      custom_role_actions           = optional(set(string), [])<br>      custom_role_data_actions      = optional(set(string), [])<br>      custom_role_not_actions       = optional(set(string), [])<br>      custom_role_not_data_actions  = optional(set(string), [])<br>      custom_role_assignable_scopes = optional(set(string), null)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (optional) namesapce for example-service-account-02, need variable to over-ride in tests. | `string` | `"default"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | (optional) Service Account name for second example, need variable to over-ride in tests. | `string` | `"example-service-account-02"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | The IDs of the apps associated with the Identities |
| <a name="output_subjects"></a> [subjects](#output\_subjects) | The subjects for the Federated Identity Credential associated with the Identities |
