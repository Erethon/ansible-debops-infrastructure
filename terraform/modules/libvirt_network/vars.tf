variable "network_name" {
  type = string
}

variable "network_mode" {
  type    = string
  default = "nat"
}

variable "network_cidr" {
  type = list(string)
}

variable "network_autostart" {
  type    = bool
  default = true
}

variable "network_bridge_interface" {
  type = string
}

variable "network_dns_enabled" {
  type    = bool
  default = true
}
