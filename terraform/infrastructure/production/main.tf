provider "libvirt" {
  uri = "${var.libvirt_uri}"
}

module "dev_network" {
  source = "../../modules/libvirt_network"

  network_bridge_interface = "virbr1"
  network_name = "dev_network"
  network_cidr = var.libvirt_cidr
  network_dns_enabled = false
}

resource "libvirt_volume" "base_debian_volume" {
  name   = "debian_base_volume"
  pool   = var.libvirt_storage_pool
  format = "qcow2"
  source = "/data/disks/debian_10_base_volume"
}

module "production_matrix" {
  source = "../../modules/libvirt_host"

  host_name = "production_matrix"
  host_memory = "1536"
  host_vcpu = 2
  storage_pool = var.libvirt_storage_pool
  volume_name = "production_matrix_volume"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.dev_network.id
  network_cidr = module.dev_network.cidr
  network_host = "2"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}

module "production_pg_matrix" {
  source = "../../modules/libvirt_host"

  host_name = "production_pg_matrix"
  host_memory = "1024"
  storage_pool = var.libvirt_storage_pool
  volume_name = "production_pg_matrix_volume"
  base_volume_id = libvirt_volume.base_debian_volume.id
  disks = [{"volume_id": libvirt_volume.base_debian_volume.id}]
  network_id = module.dev_network.id
  network_cidr = module.dev_network.cidr
  network_host = "3"
  enable_cloud_init = true
  cloudinit_user_template = <<EOF
runcmd:
  - echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
EOF
}
