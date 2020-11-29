resource "libvirt_network" "network" {
  name      = var.network_name
  mode      = var.network_mode
  addresses = var.network_cidr
  autostart = var.network_autostart
  bridge    = var.network_bridge_interface
  dns {
    enabled = var.network_dns_enabled
  }
}
