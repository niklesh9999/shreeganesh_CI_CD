terraform {
  required_version = ">= 1.16.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.5.0"
    }
  }
}




resource "azurerm_resource_group" "rg" {
  for_each = var.rg
  name     = each.value.name
  location = each.value.location

}