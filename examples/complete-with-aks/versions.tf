/**
* # Introduction
*
* This example show the example of using the module to create multiple user-managed identities and also create kubernetes resources (optional) in AKS.
* The AKS creation and dependent resources are out of this module scope. This example assumes that AKS cluster and other dependent resources are already created.
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.24"
    }
  }
  required_version = ">= 1.3"
}

provider "azurerm" {
  features {}
}


provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.example.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)

  # Using kubelogin to get an AAD token for the cluster. works with AAD enabled AKS clusters
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin" ## need kubelogin installed on the machine where terraform is running
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630", # (application used by the server side) https://azure.github.io/kubelogin/concepts/aks.html
      "--client-id",
      "80faf920-1908-4b52-b5ef-a8e7bedfc67a", # (public client application used by kubelogin) https://azure.github.io/kubelogin/concepts/aks.html
      "--tenant-id",
      "${data.azurerm_client_config.current.tenant_id}", # AAD Tenant Id
      "--login",
      "devicecode" ## expected to work only from local machine ( NO CI/CD )
    ]
  }
}
