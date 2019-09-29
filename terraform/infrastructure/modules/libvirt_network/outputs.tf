output cidr {
  value = "${var.network_cidr}"
}

output id {
  value = libvirt_network.network.id
}
