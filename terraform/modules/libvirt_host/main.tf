resource "libvirt_volume" "volume" {
  count          = (var.volume_name != "" ? 1 : 0)
  name           = var.volume_name
  pool           = var.storage_pool
  format         = var.volume_format
  size           = var.volume_size
  base_volume_id = (var.base_volume_id != "" ? var.base_volume_id : null)
}

resource "random_pet" "random" {
  count     = (var.cloudinit_user_template != "" ? 1 : 0)
  separator = "_"
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  count = (var.enable_cloud_init == true ? 1 : 0)
  name  = "cloud-init-${random_pet.random[0].id}.iso"
  pool  = var.storage_pool
  user_data = templatefile("${path.module}/user_template.yml", {
    extra_lines = var.cloudinit_user_template
  })
  network_config = templatefile("${path.module}/network_template.yml", {
    gateway     = cidrhost(var.network_cidr, 1)
    ip_address  = "${cidrhost(var.network_cidr, var.network_host)}/${split("/", var.network_cidr)[1]}"
    nameservers = var.cloudinit_nameservers
  })
}

resource "libvirt_domain" "libvirt_host" {
  name      = var.host_name
  memory    = var.host_memory
  vcpu      = var.host_vcpu
  autostart = var.host_autostart
  cloudinit = (var.cloudinit_user_template != "" ? libvirt_cloudinit_disk.cloud_init[0].id : null)

  boot_device {
    dev = ["hd"]
  }

  #disk {
  #  volume_id = (libvirt_volume.volume[0].id != "" ? libvirt_volume.volume[0].id : null)
  #}

  #disk {
  #  file = (var.iso != "" ? var.iso : null)
  #  scsi = (var.iso != "" ? false : null)
  #}

  dynamic "disk" {
    for_each = var.disks
    iterator = disk
    content {
      #file = (disk.iso != "" ? disk.iso : null)
      volume_id = (libvirt_volume.volume[0].id != "" ? libvirt_volume.volume[0].id : null)
    }
  }

  network_interface {
    network_id = (var.network_id != "" ? var.network_id : null)
    addresses  = (var.network_id != "" ? [cidrhost(var.network_cidr, var.network_host)] : null)
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}
