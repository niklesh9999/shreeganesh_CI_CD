terraform {
  required_version = ">= 1.16.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.5.0"
    }
  }
}




# data "azurerm_public_ip" "bastionpip" {
#   for_each            = var.vnet
#   name                = each.value.devpip_name
#   resource_group_name = each.value.resource_group_name
# }




# resource "azurerm_subnet" "bastion" {
#   for_each             = var.vnet
#   name                 = each.value.bastion_subnet_name
#   resource_group_name  = each.value.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet[each.key].name
#   address_prefixes     = ["10.0.2.0/26"]
# }

# resource "azurerm_bastion_host" "bastion" {
#   for_each            = var.vnet
#   name                = each.value.bastion_name
#   location            = each.value.location
#   resource_group_name = each.value.resource_group_name
#   sku                 = "Basic"

#   ip_configuration {
#     name                 = "bastion-ip-config"
#     subnet_id            = azurerm_subnet.bastion[each.key].id
#     public_ip_address_id = data.azurerm_public_ip.bastionpip[each.key].id
#   }
# }





resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
}

