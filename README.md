<!-- PROJECT SHIELDS -->
<!--
*** declarations on the bottom of this document
managed within the footer file
-->
[![License][license-shield]][license-url] [![Contributors][contributors-shield]][contributors-url] [![Issues][issues-shield]][issues-url] [![Forks][forks-shield]][forks-url] [![Stargazers][stars-shield]][stars-url]

<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h1 align="center"><strong>Azure Workload Identity</strong></h1>
  <p align="center">
    🌩️ Terraform Module For Provisioning Azure Workload Identities 🌩️
    <br/>
    <a href="https://github.com/ishuar/terraform-azure-workload-identity/issues"><strong>Report Bug</a></strong> or <a href="https://github.com/ishuar/terraform-azure-workload-identity/issues"><strong>Request Feature</a></strong>
    <br/>
    <br/>
  </p>
</div>

## Background Knowledge or External Documentation

- [What is Azure Kubernetes Service?](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes)
- [What is Azure Workload Identity?](https://azure.github.io/azure-workload-identity/docs/)

### Pre-requisites

| Name          | Version Used | Help                                                                                                 | Required |
|---------------|--------------|------------------------------------------------------------------------------------------------------|----------|
| Terraform     | `>= 1.3.0`   | [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) | Yes      |
| Azure Account | `N/A`        | [Create Azure account](https://azure.microsoft.com/en-us/free)                                       | Yes      |
<!-- | azure-cli     | `>=2.50.0`   | [Install azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)                   | Yes      | -->

**⭐️ Please consider following me on GitHub 👉 and giving a star ⭐ to the repository for future updates. ⭐️**

## Introduction

🚀 This module is your ticket to effortlessly create a Azure Workload Identities. Whether you're a seasoned cloud architect or just getting started, this module streamlines the process, giving you more time to focus on what truly matters. 🚀

## Available Features

- Multiple [Azure built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) assignments.
- Multiple [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) assignment.
- Combination of Azure built-in and custom roles on the same identity.
- Optional Kubernetes Service Account and Namespace creation when using with Azure Kubernetes Service.
- Examples to use the module.
- Support for GitHub Workflows federated user assigned identities.

## Usage

```hcl
locals {
  prefix = "azure-wi"
}

resource "azurerm_resource_group" "this" {
  location = "North Europe"
  name     = "${local.prefix}-resources"
}

module "simple" {
  source  = "ishuar/workload-identity/azure"
  version = "0.4.0"

  resource_group_name                = azurerm_resource_group.this.name
  location                           = azurerm_resource_group.this.location
  oidc_issuer_url                    = "https://token.actions.githubusercontent.com"
  create_github_workflow_credentials = true
  github_owner                       = "ishuar"
  github_repository_name             = "terraform-azure-workload-identity"
  github_entity_type                 = "pull_request" ## DEFAULT VALUE

  role_assignments = [
    ############## Azure built-in role ###############
    {
      role_definition_name = "Contributor"
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

```

## Examples

Examples are availabe in `examples` directory.

- [simple](/examples/simple)
- [multiple-identities](/examples/multiple-identities/)
- [complete-with-aks](/examples/complete-with-aks/)

**⭐️ Please consider following me on GitHub 👉 and giving a star ⭐ to the repository for future updates. ⭐️**

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.55 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~>2.24 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.55 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~>2.24 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (optional) The Azure Region where the User Assigned Identity exists. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | (Required)The URL of the OIDC issuer for the cluster | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (optional) Resource group name. If not set, the default resource group will be used. | `string` | n/a | yes |
| <a name="input_additional_service_account_annotations"></a> [additional\_service\_account\_annotations](#input\_additional\_service\_account\_annotations) | (optional) Additional Annotations for the new service account created. | `map(string)` | `{}` | no |
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | (Optional) To enable automatic mounting of the service account token. Defaults to true | `bool` | `false` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | (optional) GitHub branch name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `branch`. | `string` | `""` | no |
| <a name="input_create_github_workflow_credentials"></a> [create\_github\_workflow\_credentials](#input\_create\_github\_workflow\_credentials) | (optional) Whether to create federated credentials for GitHub workflow or not?. Default is to to create credentials for Azure kubernetes service accounts. If set to `true`, then `github_owner`, 'github\_entity\_type' and `github_repository_name` must be set. | `bool` | `false` | no |
| <a name="input_create_kubernetes_namespace"></a> [create\_kubernetes\_namespace](#input\_create\_kubernetes\_namespace) | (optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create\_namespace' is set to false | `bool` | `false` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | (optional) Whether or not to create kubernetes service account via terraform-kubernetes-provider? Use this if helm chart supports existing service account name. | `bool` | `false` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | (optional) GitHub environment name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `environment`. | `string` | `""` | no |
| <a name="input_github_entity_type"></a> [github\_entity\_type](#input\_github\_entity\_type) | (optional) The filter used to scope the OIDC requests from GitHub workflows. This field is used to generate the subject claim. Accepted values are 'environment', 'branch', 'tag' or 'pull\_request'. Required when `create_github_actions_credential` is set to `true`. | `string` | `"pull_request"` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | (optional) GitHub organization name or GitHub username that owns the repository where github workflow will use federated credentials. Required when `create_github_actions_credential` is set to `true`. | `string` | `""` | no |
| <a name="input_github_repository_name"></a> [github\_repository\_name](#input\_github\_repository\_name) | (optional)GitHub Repository name where github workflow will use federated credentials. Required when `create_github_actions_credential` is set to `true`. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (optional) The namespace where service account will be created. New will be created if value is not equeal to kube-sytem and default.Required when `create_github_actions_credential` is set to `false`. | `string` | `""` | no |
| <a name="input_namespace_annotations"></a> [namespace\_annotations](#input\_namespace\_annotations) | (optional) Annotations for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_namespace_labels"></a> [namespace\_labels](#input\_namespace\_labels) | (optional) Labels for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | (optional) The role assignments for the service account.<br><br>`role_definition_name`:  The name of a role which either needs to be used (azure built-in) or new one you want to create.<br>`name` : A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created.<br>`condition`:  The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.<br>`condition_version`: (Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created.<br>`create_custom_role` : Whether or not to create a custom role. If set to true, then any of the custom\_role\_actions,custom\_role\_data\_actions, custom\_role\_not\_actions, custom\_role\_not\_data\_actions, custom\_role\_assignable\_scopes are required.<br>`scope` : The scope at which the role assignment or custom role will be created.<br>`custom_role_definition_id`: (Optional) A unique UUID/GUID which identifies this role - one will be generated if not specified. Changing this forces a new resource to be created.Only valid for custom role.<br>`custom_role_actions`: One or more Allowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read. See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.<br>`custom_role_data_actions` : One or more Allowed Data Actions, such as *, Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read. See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.<br>`custom_role_not_actions` : One or more Denied Actions, such as Microsoft.Compute/virtualMachines/write.See [Azure Resource Manager resource provider operations](https://learn.microsoft.com/en-gb/azure/role-based-access-control/resource-provider-operations) for details. Only valid for custom role.<br>`custom_role_not_data_actions` : One or more Disallowed Data Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read<br>`custom_role_assignable_scopes` : One or more assignable scopes for this Role Definition. The value for scope is automatically included in this list if no other values supplied<br>`custom_role_description` : A description of the role. Only valid for custom role definition. | <pre>set(object({<br>    role_definition_name          = optional(string)<br>    name                          = optional(string, null)<br>    create_custom_role            = optional(bool, false)<br>    condition                     = optional(string, null)<br>    condition_version             = optional(string, null)<br>    scope                         = optional(string)<br>    custom_role_description       = optional(string)<br>    custom_role_definition_id     = optional(string, null)<br>    custom_role_actions           = optional(set(string), [])<br>    custom_role_data_actions      = optional(set(string), [])<br>    custom_role_not_actions       = optional(set(string), [])<br>    custom_role_not_data_actions  = optional(set(string), [])<br>    custom_role_assignable_scopes = optional(set(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | (optional) The name of the service account which is using the workload identity. Required when `create_github_actions_credential` is set to `false`. | `string` | `""` | no |
| <a name="input_service_account_token_expiration_seconds"></a> [service\_account\_token\_expiration\_seconds](#input\_service\_account\_token\_expiration\_seconds) | (optional) Represents the expirationSeconds field for the projected service account token | `number` | `86400` | no |
| <a name="input_tag_name"></a> [tag\_name](#input\_tag\_name) | (optional) GitHub tag name which uses the github workflow with federated credentials. Required when `github_entity_type` is set to `tag`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the User Assigned Identity. | `map(string)` | `{}` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | (optional) Whether to use existing resource group or create a new one? | `string` | `true` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | (optional) Name of User Assigned Identity to create. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The ID of the app associated with the Identity |
| <a name="output_id"></a> [id](#output\_id) | The ID of the User Assigned Identity. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The ID of the Service Principal object associated with the created Identity. |
| <a name="output_subject"></a> [subject](#output\_subject) | The subject for this Federated Identity Credential |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The ID of the Tenant which the Identity belongs to |

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have any suggestion that would make this project better, feel free to  fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement" with your suggestion.

**⭐️ Don't forget to give the project a star! Thanks again! ⭐️**

<!-- LICENSE -->
## License

Released under [MIT](/LICENSE) by [@ishuar](https://github.com/ishuar).

<!-- CONTACT -->
## Contact

- 👯 [LinkedIn](https://linkedin.com/in/ishuar)

<p align="right"><a href="#top">Back To Top ⬆️</a></p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-url]: https://github.com/ishuar/terraform-azure-workload-identity/graphs/contributors
[contributors-shield]: https://img.shields.io/github/contributors/ishuar/terraform-azure-workload-identity?style=for-the-badge

[forks-url]: https://github.com/ishuar/terraform-azure-workload-identity/network/members
[forks-shield]: https://img.shields.io/github/forks/ishuar/terraform-azure-workload-identity?style=for-the-badge

[stars-url]: https://github.com/ishuar/terraform-azure-workload-identity/stargazers
[stars-shield]: https://img.shields.io/github/stars/ishuar/terraform-azure-workload-identity?style=for-the-badge

[issues-url]: https://github.com/ishuar/terraform-azure-workload-identity/issues
[issues-shield]: https://img.shields.io/github/issues/ishuar/terraform-azure-workload-identity?style=for-the-badge

[license-url]: https://github.com/ishuar/terraform-azure-workload-identity/blob/main/LICENSE
[license-shield]: https://img.shields.io/github/license/ishuar/terraform-azure-workload-identity?style=for-the-badge