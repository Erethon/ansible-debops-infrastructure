resource "libvirt_volume" "volume" {
  count     = (var.volume_name != "" ? 1 : 0)
  name           = var.volume_name
  pool           = var.storage_pool
  format         = var.volume_format
  size           = var.volume_size
  base_volume_id = (var.base_volume_id != "" ? var.base_volume_id : null)
}

resource "random_pet" "random" {
  count     = (var.cloudinit_template != "" ? 1 : 0)
  separator = "_"
}

data "template_file" "user_data" {
  count    = (var.cloudinit_template != "" ? 1 : 0)
  template = var.cloudinit_template
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  count     = (var.cloudinit_template != "" ? 1 : 0)
  name      = "cloud-init-${random_pet.random[0].id}.iso"
  user_data = data.template_file.user_data[count.index].rendered
  pool      = var.storage_pool
}

resource "libvirt_domain" "libvirt_host" {
  name      = var.host_name
  memory    = var.host_memory
  vcpu      = var.host_vcpu
  autostart = var.host_autostart
  cloudinit = (var.cloudinit_template != "" ? libvirt_cloudinit_disk.cloud_init[0].id : null)

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
