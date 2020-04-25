variable "network_id" {
  type    = string
  default = ""
}

variable "network_cidr" {
  type    = string
  default = ""
}
variable "network_host" {
  type    = number
  default = 0
}

variable "host_name" {
  type = string
}

variable "host_memory" {
  type    = number
  default = 512
}

variable "host_vcpu" {
  type    = number
  default = 1
}

variable "host_autostart" {
  type    = bool
  default = true
}

variable "storage_pool" {
  type = string
  default = "default"
}

variable "volume_name" {
  type = string
  default = ""
}

variable "volume_size" {
  type    = number
  default = 10737418240
}

variable "volume_format" {
  type    = string
  default = "qcow2"
}

variable "volume_source" {
  type    = string
  default = ""
}

variable "cloudinit_user_template" {
  type    = string
  default = ""
}

variable "enable_cloud_init" {
  type = bool
  default = false
}

variable "cloudinit_nameservers" {
  type = list
  default = ["88.198.92.222"]
}

variable "base_volume_id" {
  type = string
  default = ""
}

variable "iso" {
  type = string
  default = ""
}

variable "disks" {
  type = list
  default = []
}
