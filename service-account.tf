locals {
  create_namespace_via_this_module = var.create_kubernetes_namespace && var.namespace != "kube-system" && var.namespace != "default" ? 1 : 0
}

resource "kubernetes_namespace_v1" "this" {
  count = local.create_namespace_via_this_module

  metadata {
    labels      = var.namespace_labels
    name        = var.namespace
    annotations = var.namespace_annotations
  }

  timeouts {
    delete = "15m"
  }
}

resource "kubernetes_service_account_v1" "this" {
  count = var.create_service_account ? 1 : 0

  automount_service_account_token = var.automount_service_account_token
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = merge(
      {
        "azure.workload.identity/client-id"                        = azurerm_user_assigned_identity.this.client_id
        "azure.workload.identity/tenant-id"                        = data.azurerm_client_config.current.tenant_id
        "azure.workload.identity/service-account-token-expiration" = var.service_account_token_expiration_seconds
      }
    , var.additional_service_account_annotations)
  }
}
