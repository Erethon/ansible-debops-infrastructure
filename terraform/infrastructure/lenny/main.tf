provider "libvirt" {
  uri = var.libvirt_uri
}

module "lenny_network" {
  source = "../../modules/libvirt_network"

  network_bridge_interface = "virbr1"
  network_name             = "lenny_network"
  network_cidr             = "192.168.134.0/24"
  network_dns_enabled      = false
}

resource "libvirt_volume" "base_debian_volume" {
  name   = "debian_base_volume"
  pool   = libvirt_pool.disk_pool.name
  format = "qcow2"
  source = "/home/tp/Disks/packer-debian10-base-v2"
}

resource "libvirt_pool" "disk_pool" {
  name = "tf_pool"
  type = "dir"
  path = "/data/Disks"
}

module "dirty_debian_dev" {
  source = "../../modules/libvirt_host"

  host_name               = "dirty_debian_dev"
  host_memory             = "512"
  host_vcpu               = 1
  host_autostart          = false
  storage_pool            = libvirt_pool.disk_pool.name
  volume_name             = "dirty_debian_dev"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.lenny_network.id
  network_cidr            = module.lenny_network.cidr
  network_host            = "2"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "nv_core" {
  source = "../../modules/libvirt_host"

  host_name               = "nc_core"
  host_memory             = "512"
  host_vcpu               = 1
  host_autostart          = false
  storage_pool            = libvirt_pool.disk_pool.name
  volume_name             = "nv_core"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.lenny_network.id
  network_cidr            = module.lenny_network.cidr
  network_host            = "3"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "tor_proxy" {
  source = "../../modules/libvirt_host"

  host_name               = "tor_proxy"
  host_memory             = "256"
  host_vcpu               = 1
  host_autostart          = false
  storage_pool            = libvirt_pool.disk_pool.name
  volume_name             = "tor_proxy"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.lenny_network.id
  network_cidr            = module.lenny_network.cidr
  network_host            = "4"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}
