terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.55"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.24"
    }
  }
  required_version = ">= 1.3"
}
