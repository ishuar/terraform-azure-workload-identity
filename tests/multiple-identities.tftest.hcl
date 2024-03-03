## Test to ensure that azure workload identity is created as expected.
## This test is run as part of the CI/CD pipeline.

run "multiple_identities" {
  module {
    source = "../examples/multiple-identities"
  }
  assert {
    condition     = module.combination_service_accounts_and_github_workflow_identities["${var.service_account_name}"].subject == "system:serviceaccount:${var.namespace}:${var.service_account_name}"
    error_message = "Unexpected federated credential subject for service account ${var.service_account_name}"
  }
}
