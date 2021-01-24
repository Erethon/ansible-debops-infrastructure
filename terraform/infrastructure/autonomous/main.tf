provider "libvirt" {
  uri = var.libvirt_uri
}

module "autonomous_network" {
  source = "../../modules/libvirt_network"

  network_bridge_interface = "virbr1"
  network_name             = "autonomous_network"
  network_cidr             = ["192.168.133.0/24", "2a01:4f8:211:1418::/116"]
  network_dns_enabled      = false
}

resource "libvirt_pool" "tf_pool" {
  name = var.libvirt_storage_pool
  type = "dir"
  path = "/opt/Disks/${var.libvirt_storage_pool}"
}

resource "libvirt_volume" "base_debian_volume" {
  name   = "debian_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/opt/Disks/packer-debian10-base"
}

module "k3s_1" {
  source   = "../../modules/libvirt_host"
  for_each = toset(["2", "3", "4"])

  host_name               = "k3s_${each.key}"
  host_memory             = "2048"
  host_vcpu               = 2
  storage_pool            = var.libvirt_storage_pool
  volume_name             = "k3s_${each.key}"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.autonomous_network.id
  network_cidr            = module.autonomous_network.cidr[0]
  network_host            = each.key
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}
