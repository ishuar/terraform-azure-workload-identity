/**
* # Introduction
*
* This example show the example of using the module to create a multiple user-managed identities and assign a combination of azure built-in and newly created custom role definitions for Github workflows and Kubernetes Servic Accounts either individually or combination.
*
* Refer to each individual module interfaces `multiple_service_account_identities`,`multiple_github_workflow_identities` and `combination_service_accounts_and_github_workflow_identities` for more details.
*
* > :information_source: Individual usage of Module for GitHub Workflow and Kubernetes Service Account Identities is recommended to simplify configuration and reduce blast radius.
*/

provider "azurerm" {
  features {}
}
