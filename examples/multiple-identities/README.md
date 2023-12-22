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

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | The IDs of the apps associated with the Identities |
| <a name="output_subjects"></a> [subjects](#output\_subjects) | The subjects for the Federated Identity Credential associated with the Identities |
