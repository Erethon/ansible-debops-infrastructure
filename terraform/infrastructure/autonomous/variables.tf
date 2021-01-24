variable "libvirt_uri" {
  description = "URI for libvirt to use"
  default     = "qemu:///system"
}

variable "libvirt_storage_pool" {
  description = "Storage pool to use for VM disks"
  default     = "tf_pool"
}
