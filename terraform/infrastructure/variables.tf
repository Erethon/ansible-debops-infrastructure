variable "libvirt_uri" {
  description = "URI for libvirt to use"
  default = "qemu+ssh://user@host/system"
}

variable "libvirt_storage_pool" {
  description = "Storage pool to use for VM disks"
  default = "tf_pool"
}

variable "libvirt_cidr" {
  description = "Network CIDR to use for VMs"
  default = ["192.168.199.0/24"]
}
