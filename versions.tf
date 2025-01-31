terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.15"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.24"
    }
  }
  required_version = ">= 1.8"
}
