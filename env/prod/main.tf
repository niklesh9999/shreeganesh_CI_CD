module "rg" {
  source = "../../module/rg"
  rg     = var.rg

}

module "vnet" {
  depends_on = [ module.rg ]
  source = "../../module/vnet"
  vnet   = var.vnet

}

module "nsg" {
  depends_on = [ module.rg ]
  source = "../../module/nsg"
  nsg    = var.nsg
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../../module/subnet"
  subnet     = var.subnet


}



module "nsga" {
  depends_on = [ module.subnet,module.nsg ]
  source = "../../module/nsga"

  nsga = {
    for key, value in var.nsga : key => {
      subnet_id                 = module.subnet.subnet_ids[value.subnet_id]
      network_security_group_id = module.nsg.nsg_ids[value.nsg_id]
    }
  }
}

module "pip" {
  depends_on = [module.rg]
  source     = "../../module/public_ip"
  pip        = var.pip

}


module "vm" {
  # depends_on = [ module.subnet, module.pip]
  source = "../../module/vm"
  vm = {
    for key, value in var.vm : key => merge(value, {
      subnet_id = module.subnet.subnet_ids[value.subnet_id]

      }
    )

  }
}