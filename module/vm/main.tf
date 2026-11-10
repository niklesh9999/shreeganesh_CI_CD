terraform {
  required_version = ">= 1.16.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.5.0"
    }
  }
}




data "azurerm_key_vault" "firstkeyvault" {
  for_each            = var.vm
  name                = each.value.key_vault_name
  resource_group_name = each.value.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "username" {
  for_each     = var.vm
  name         = each.value.username_secret_name
  key_vault_id = data.azurerm_key_vault.firstkeyvault[each.key].id
}

data "azurerm_key_vault_secret" "password" {
  for_each     = var.vm
  name         = each.value.password_secret_name
  key_vault_id = data.azurerm_key_vault.firstkeyvault[each.key].id
}




resource "azurerm_network_interface" "nic" {
  for_each = var.vm

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = each.value.private_ip_address_allocation

    public_ip_address_id = each.value.public_ip_id
  }
}

#checkov:skip=CKV_AZURE_50:VM extensions are intentionally not used in this project.
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vm

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size

  admin_username = data.azurerm_key_vault_secret.username[each.key].value
  admin_password = data.azurerm_key_vault_secret.password[each.key].value

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  # Enable password authentication
  disable_password_authentication = false

  # SSH key authentication
  admin_ssh_key {
    username   = data.azurerm_key_vault_secret.username[each.key].value
    public_key = each.value.ssh_public_key
  }

  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}