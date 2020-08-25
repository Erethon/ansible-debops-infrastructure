provider "libvirt" {
  uri = "${var.libvirt_uri}"
}

resource "libvirt_network" "production_network" {
  name      = "production_network"
  mode      = "nat"
  addresses = ["${var.libvirt_cidr}"]
  autostart = true
  bridge    = "virbr2"
}

resource "libvirt_volume" "debian_prometheus_disk" {
  name   = "debian_prometheus_disk"
  pool   = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size   = 10737418240
}

resource "libvirt_volume" "debian_container_disk" {
  name   = "debian_container"
  pool   = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size   = 21474836480
}

resource "libvirt_volume" "debian_matrix_disk" {
  name   = "debian_matrix"
  pool   = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size   = 21474836480
}

resource "libvirt_domain" "debian_container_domain" {
  name      = "debian_container"
  memory    = "1024"
  vcpu      = 2
  autostart = "true"

  boot_device {
    dev = ["hd"]
  }

  disk {
    volume_id = "${libvirt_volume.debian_container_disk.id}"
  }

  network_interface {
    network_id = "${libvirt_network.production_network.id}"
    addresses  = [cidrhost("${var.libvirt_cidr}", 4)]
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}
