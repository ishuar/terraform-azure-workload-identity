## tftest.hcl needs terraform config as it neeed to init the module.
## And terraform can not init in empty directory.
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
provider "azurerm" {
  features {}
}
