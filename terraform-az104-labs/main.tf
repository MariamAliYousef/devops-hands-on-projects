# Define required Terraform providers and their versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.6.0"
    }
    azuread = {
            source  = "hashicorp/azuread"
            version = "2.41.0"
        }
  }
}
# Configure the Azure Resource Manager provider with default features enabled
provider "azurerm" {
  features {}
}

# Create a new resource group to house all infrastructure resources for this lab
resource "azurerm_resource_group" "rg" {
  name     = "rg-az104-demo"
  location = "East US"
}
