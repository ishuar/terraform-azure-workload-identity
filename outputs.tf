output "client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The ID of the app associated with the Identity"
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "The ID of the Service Principal object associated with the created Identity."
}

output "id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The ID of the User Assigned Identity."
}

output "tenant_id" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "The ID of the Tenant which the Identity belongs to"
}

output "subject" {
  value       = azurerm_federated_identity_credential.this.subject
  description = "The subject for this Federated Identity Credential"
}
