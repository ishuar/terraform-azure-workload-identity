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

