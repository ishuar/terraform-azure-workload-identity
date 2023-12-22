/**
* # Introduction
*
* This example show the simplest example of using the module to create a single user-managed identity and assign one custom and built-in role to it respectively.
*/

locals {
  prefix = "wi-module"

  tags = {
    github_repo = "ishuar/terraform-azure-workload-identity"
    managed_by  = "terraform"
    used_case   = "tf-az-wi-module-dev"
  }
}
