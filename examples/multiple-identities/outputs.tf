output "client_ids" {
  value       = { for k, v in module.multiple_identities : k => v.client_id }
  description = "The IDs of the apps associated with the Identities"
}

output "subjects" {
  value       = { for k, v in module.multiple_identities : k => v.subject }
  description = "The subjects for the Federated Identity Credential associated with the Identities"
}
