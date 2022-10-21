provider "libvirt" {
  uri = var.libvirt_uri
}

module "ori_network" {
  source = "../../modules/libvirt_network"

  network_bridge_interface = "virbr1"
  network_name             = "ori_network"
  network_cidr             = ["192.168.144.0/24"]
  network_dns_enabled      = false
}

resource "libvirt_volume" "base_debian_volume" {
  name   = "debian_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-debian10-base-v2"
}

resource "libvirt_volume" "base_debian_volume_v3" {
  name   = "debian_base_volume_v3"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-debian10-base-v6"
}

resource "libvirt_volume" "base_debian_11_volume" {
  name   = "debian_base_11_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-debian11-base-v1"
}

resource "libvirt_volume" "base_openbsd_volume" {
  name   = "openbsd_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-openbsd7.2-base"
}

module "dirty_debian_dev" {
  source = "../../modules/libvirt_host"

  host_name               = "dirty_debian_dev"
  host_memory             = "2048"
  host_vcpu               = 2
  storage_pool            = var.libvirt_storage_pool
  volume_name             = "dirty_debian_dev"
  base_volume_id          = libvirt_volume.base_debian_11_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_11_volume.id }]
  network_id              = module.ori_network.id
  network_cidr            = module.ori_network.cidr[0]
  network_host            = "2"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
  host_autostart          = false
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "openbsd_72" {
  source = "../../modules/libvirt_host"

  host_name         = "openbsd72"
  host_memory       = "2048"
  host_vcpu         = 2
  storage_pool      = var.libvirt_storage_pool
  volume_name       = "openbsd_72"
  base_volume_id    = libvirt_volume.base_openbsd_volume.id
  disks             = [{ "volume_id" : libvirt_volume.base_openbsd_volume.id }]
  network_id        = module.ori_network.id
  network_cidr      = module.ori_network.cidr[0]
  network_host      = "4"
  enable_cloud_init = false
  host_autostart    = false
}

module "xorg_enabled" {
  source = "../../modules/libvirt_host"

  host_name               = "xorg_enabled"
  host_memory             = "2048"
  host_vcpu               = 1
  storage_pool            = var.libvirt_storage_pool
  volume_name             = "xorg_enabled"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.ori_network.id
  network_cidr            = module.ori_network.cidr[0]
  network_host            = "5"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
  host_autostart          = false
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "rust_dev" {
  source = "../../modules/libvirt_host"

  host_name               = "rust_dev"
  host_memory             = "4096"
  host_vcpu               = 4
  storage_pool            = var.libvirt_storage_pool
  volume_name             = "rust_dev"
  volume_size             = "16106127360"
  base_volume_id          = libvirt_volume.base_debian_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_volume.id }]
  network_id              = module.ori_network.id
  network_cidr            = module.ori_network.cidr[0]
  network_host            = "7"
  host_autostart          = false
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "kali_live" {
  source = "../../modules/libvirt_host"

  host_name       = "kali_live"
  host_memory     = "4096"
  host_vcpu       = 4
  storage_pool    = var.libvirt_storage_pool
  disks           = [{ "iso" : "/home/bsd/Disks/kali-linux-2020.4-live-amd64.iso" }]
  network_id      = module.ori_network.id
  network_cidr    = module.ori_network.cidr[0]
  network_host    = "22"
  enable_graphics = true
  host_autostart  = false
}

module "tails_live" {
  source = "../../modules/libvirt_host"

  host_name       = "tails_live"
  host_memory     = "4096"
  host_vcpu       = 6
  storage_pool    = var.libvirt_storage_pool
  disks           = [{ "iso" : "/home/bsd/Disks/tails-amd64-5.4.iso" }]
  network_id      = module.ori_network.id
  network_cidr    = module.ori_network.cidr[0]
  network_host    = "23"
  enable_graphics = true
  host_autostart  = false
}

module "red_team_oricono" {
  source = "../../modules/libvirt_host"

  host_name               = "red_team_oricono"
  host_memory             = "2048"
  host_vcpu               = 2
  storage_pool            = var.libvirt_storage_pool
  volume_name             = "red_team_oricono"
  base_volume_id          = libvirt_volume.base_debian_11_volume.id
  disks                   = [{ "volume_id" : libvirt_volume.base_debian_11_volume.id }]
  network_id              = module.ori_network.id
  network_cidr            = module.ori_network.cidr[0]
  network_host            = "3"
  enable_cloud_init       = true
  cloudinit_user_template = <<EOF
  host_autostart          = false
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}
