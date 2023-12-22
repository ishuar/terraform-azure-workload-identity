output "client_id" {
  value       = module.simple.client_id
  description = "The ID of the app associated with the Identity"
}

output "subject" {
  value       = module.simple.subject
  description = "The subject for this Federated Identity Credential"
}
