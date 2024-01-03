data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "example" {
  name = "rg-${var.prefix}"
}

data "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-aks"
  resource_group_name = data.azurerm_resource_group.example.name
}

data "azurerm_dns_zone" "example" {
  name                = var.dns_zone_name
  resource_group_name = data.azurerm_resource_group.example.name
}

module "complete_with_aks" {
  for_each = { for identity in local.identities : identity.service_account_name => identity }

  source                      = "../../"
  resource_group_name         = data.azurerm_resource_group.example.name
  location                    = data.azurerm_resource_group.example.location
  oidc_issuer_url             = data.azurerm_kubernetes_cluster.example.oidc_issuer_url
  service_account_name        = each.value.service_account_name
  namespace                   = each.value.namespace
  role_assignments            = each.value.role_assignments

  ## Create Kubernetes resources
  create_kubernetes_namespace = try(each.value.create_kubernetes_namespace, false)
  create_service_account      = try(each.value.create_service_account, false)

  depends_on = [
    data.azurerm_kubernetes_cluster.example,
    data.azurerm_dns_zone.example
  ]
}
