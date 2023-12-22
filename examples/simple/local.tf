locals {
  prefix = "wi-sim-module"

  tags = {
    github_repo = "ishuar/terraform-azure-workload-identity"
    managed_by  = "terraform"
    used_case   = "tf-az-wi-module-dev"
  }
}
