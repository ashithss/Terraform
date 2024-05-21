terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features { }
tenant_id= "df011998-1ab4-464a-a1b2-64c9719ed21b" 
}