# resource "azurerm_subnet_network_security_group_association" "nsga" {
#   for_each = var.nsga
#   subnet_id                 = data.azurerm_subnet.subnet["subnet1"].id
#   network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
# }


resource "azurerm_subnet_network_security_group_association" "nsga" {
  for_each = var.nsga
  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.network_security_group_id
}