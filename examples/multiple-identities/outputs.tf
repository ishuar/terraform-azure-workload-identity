# output "multiple_service_account_identities_client_ids" {
#   value       = { for k, v in module.multiple_service_account_identities : k => v.client_id }
#   description = "The Client IDs of the apps associated with the Identities."
# }

# output "multiple_service_account_identities_subjects" {
#   value       = { for k, v in module.multiple_service_account_identities : k => v.subject }
#   description = "The subjects for the Federated Identity Credential associated with the Identities."
# }

# output "multiple_github_workflow_identities_client_ids" {
#   value       = { for k, v in module.multiple_github_workflow_identities : k => v.client_id }
#   description = "The Client IDs of the apps associated with the Identities."
# }

# output "multiple_github_workflow_identities_subjects" {
#   value       = { for k, v in module.multiple_github_workflow_identities : k => v.subject }
#   description = "The subjects for the Federated Identity Credential associated with the Identities."
# }

output "combination_service_accounts_and_github_workflow_client_ids" {
  value       = { for k, v in module.combination_service_accounts_and_github_workflow_identities : k => v.client_id }
  description = "The Client IDs of the apps associated with the Identities."
}

output "combination_service_accounts_and_github_workflow_subjects" {
  value       = { for k, v in module.combination_service_accounts_and_github_workflow_identities : k => v.subject }
  description = "The subjects for the Federated Identity Credential associated with the Identities."
}
