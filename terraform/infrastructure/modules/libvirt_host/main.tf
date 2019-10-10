resource "libvirt_volume" "base_volume" {
  count  = (var.volume_source == "" ? 0 : 1)
  name   = "base_debian_10_image"
  pool   = var.storage_pool
  format = var.volume_format
  source = var.volume_source
}

resource "libvirt_volume" "volume" {
  name           = var.volume_name
  pool           = var.storage_pool
  format         = var.volume_format
  size           = var.volume_size
  base_volume_id = (var.volume_source != "" ? libvirt_volume.base_volume[0].id : null)
}

data "template_file" "user_data" {
  count    = (var.cloudinit_template != "" ? 1 : 0)
  template = var.cloudinit_template
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  count     = (var.cloudinit_template != "" ? 1 : 0)
  name      = "cloud-init.iso"
  user_data = "${data.template_file.user_data[count.index].rendered}"
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

  disk {
    volume_id = libvirt_volume.volume.id
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
