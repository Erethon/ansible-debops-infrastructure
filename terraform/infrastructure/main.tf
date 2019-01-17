provider "libvirt" {
  uri = "${var.libvirt_uri}"
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
