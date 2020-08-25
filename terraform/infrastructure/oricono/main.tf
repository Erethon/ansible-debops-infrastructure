provider "libvirt" {
  uri = var.libvirt_uri
}

module "ori_network" {
  source = "../../modules/libvirt_network"

  network_bridge_interface = "virbr1"
  network_name = "ori_network"
  network_cidr = "192.168.144.0/24"
  network_dns_enabled = false
}

resource "libvirt_volume" "base_debian_volume" {
  name   = "debian_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-debian10-base-v2"
}

resource "libvirt_volume" "base_openbsd_volume" {
  name   = "openbsd_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/home/bsd/Disks/packer-openbsd6.7-base"
}

module "dirty_debian_dev" {
  source = "../../modules/libvirt_host"

  host_name = "dirty_debian_dev"
  host_memory = "1024"
  host_vcpu = 2
  storage_pool = var.libvirt_storage_pool
  volume_name = "dirty_debian_dev"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "2"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "nv_core" {
  source = "../../modules/libvirt_host"

  host_name = "nc_core"
  host_memory = "1024"
  host_vcpu = 1
  storage_pool = var.libvirt_storage_pool
  volume_name = "nv_core"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "3"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "openbsd_67" {
  source = "../../modules/libvirt_host"

  host_name = "openbsd67"
  host_memory = "512"
  host_vcpu = 1
  storage_pool = var.libvirt_storage_pool
  volume_name = "opnbsd_67"
  base_volume_id = libvirt_volume.base_openbsd_volume.id
  disks = [{"volume_id": libvirt_volume.base_openbsd_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "4"
  enable_cloud_init = false
}

module "xorg_enabled" {
  source = "../../modules/libvirt_host"

  host_name = "xorg_enabled"
  host_memory = "1024"
  host_vcpu = 1
  storage_pool = var.libvirt_storage_pool
  volume_name = "xorg_enabled"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "5"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "es_test" {
  source = "../../modules/libvirt_host"

  host_name = "es_test"
  host_memory = "2048"
  host_vcpu = 4
  storage_pool = var.libvirt_storage_pool
  volume_name = "es_test"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "6"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "rust_dev" {
  source = "../../modules/libvirt_host"

  host_name = "rust_dev"
  host_memory = "1024"
  host_vcpu = 2
  storage_pool = var.libvirt_storage_pool
  volume_name = "rust_dev"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.ori_network.id
  network_cidr = module.ori_network.cidr
  network_host = "7"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}
