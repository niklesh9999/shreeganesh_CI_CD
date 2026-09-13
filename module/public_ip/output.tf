# output "pip_ids" {
#     value = {
#         for key, public_ip in azurerm_public_ip.pip:
#         key => public_ip.id
#     }

# }