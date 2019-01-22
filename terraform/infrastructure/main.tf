provider "libvirt" {
  uri = "${var.libvirt_uri}"
}

resource "libvirt_volume" "debian_jenkins" {
  name = "debian_jenkins"
  pool = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size = 21474836480
}

resource "libvirt_volume" "debian_dev" {
  name = "debian_dev"
  pool = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size = 10737418240
}

resource "libvirt_volume" "obsd_dev" {
  name = "obsd_dev"
  pool = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size = 10737418240
}

resource "libvirt_network" "dev_network" {
  name = "dev_network"
  mode = "nat"
  addresses = "${var.libvirt_cidr}"
  autostart = true
  bridge = "virbr1"
}

resource "libvirt_volume" "obsd_dn42" {
  name = "obsd_dn42"
  pool = "${var.libvirt_storage_pool}"
  format = "qcow2"
  size = 10737418240
}

resource "libvirt_domain" "obsd_dev_domain" {
  name     = "obsd_dev"
  memory   = "1024"
  vcpu     = 2
  autostart = "true"

  boot_device {
    dev = ["hd"]
  }

  ## Not needed after initial installation
  ## disk {
  ##   file = "${var.openbsd_iso}"
  ## }

  disk {
    volume_id = "${libvirt_volume.obsd_dev.id}"
  }

  network_interface {
    network_id = "${libvirt_network.dev_network.id}"
    addresses = ["192.168.199.2"]
  }

  graphics {
    type = "spice"
    listen_type = "none"
  }
}

resource "libvirt_domain" "debian_jenkins_domain" {
  name     = "debian_jenkins"
  memory   = "2048"
  vcpu     = 2
  autostart = "true"

  boot_device {
    dev = ["hd"]
  }

  disk {
    volume_id = "${libvirt_volume.debian_jenkins.id}"
  }

  network_interface {
    network_id = "${libvirt_network.dev_network.id}"
    addresses = ["192.168.199.3"]
  }

  graphics {
    type = "spice"
    listen_type = "none"
  }
}

resource "libvirt_domain" "debian_dev_domain" {
  name     = "debian_dev"
  memory   = "512"
  vcpu     = 1
  autostart = "true"

  boot_device {
    dev = ["hd"]
  }

  disk {
    volume_id = "${libvirt_volume.debian_dev.id}"
  }

  network_interface {
    network_id = "${libvirt_network.dev_network.id}"
    addresses = ["192.168.199.4"]
  }

  graphics {
    type = "spice"
    listen_type = "none"
  }
}
