module "vm" {
  source = "../modules/vm"
  count  = length(var.name)
  name   = var.name[count.index]
}
# Same as the previous example, but using for_each instead of count:
# module "vm" {
#   source   = "../modules/vm"
#   for_each = toset(var.name)
#   name     = each.value
# }

# Below is the content of the manifest.tftpl file,
# a template file that will be used to generate the inventory.csv file
# using the templatefile function.
# it takes a list of IP addresses and generates a CSV file with the IP addresses.
resource "local_file" "IPs" {
  filename = "./inventory.csv"
  content = templatefile("manifest.tftpl", { ip_addrs = {
    int = module.vm.*.ip,
    ext = module.vm.*.ext_ip
    }
    }
  )
}
