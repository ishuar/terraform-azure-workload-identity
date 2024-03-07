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
