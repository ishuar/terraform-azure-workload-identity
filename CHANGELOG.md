# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
## version

### Breaking
  - Changes which may cause recreation of cluster or resources.

### Added
  - Added new feature

### Fixed
  - Bug fixes

### Removed
  - Removed/Deprecated features

### Others
  - Other changes

-->

## v0.4.1

### Others
- Upgrade `terraform` and `azurerm` version, so the provider functions normalise_resource_id and parse_resource_id are available to use.

## v0.4.0

### Added
- Feature to support for `GitHub Workflows` as the federated credential's subject in previous versions was only compatible with kubernetes service accounts.
  - Reference Docs:
    - [MS: Use GitHub Actions to connect to Azure](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux)
    - [GitHub: Configuring OpenID Connect in Azure ](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)
  - Precondtions checks
    - To support multiple github_entity_type.
    - `namespace` and `service_account_name` are still required if `create_github_workflow_credentials` is set to false.
  - Disable `github_workflow_credentials` by default

### Others

- Adjusted terraform resource `azurerm_role_assignment` key with respect to `github_workflow` feature. Using `gh-repo-REPO_NAME`.
- `simple` example is referring to only `github_workflow_credentials` usage, Use `multiple-identities` example for both features (kubernetes service account and github workflows).

## v0.3.0

### Added
- Added complete example for creating multiple identities and kubernetes resources in azure kubernetes service.

### Fixed
- Fix typos in the readme.

## v0.2.0

### Added
- Added example for creating multiple identities using individual combination of azure built-in and custom roles.

### Others
- Added automated tests for the example `multiple-identities`.
  - To verify the core functionality of the module , create identities, assign multiple role and generate federated credentials.

## v0.1.0

### Added

- First version of Module.
  -  Available Features
     - Multiple [Azure built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) assignments.
     - Multiple [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) assignment.
     - Combination of Azure built-in and custom roles on the same identity.
     - Optional Kubernetes Service Account and Namespace creation when using with Azure Kubernetes Service.
     - Simple example to use the module just for the workload identity azure resources.

  - Considerations
    - Please read the variable descriptions in the [variables.tf](./variables.tf) to be aware about the usage of the inputs.
