terraform {
  required_providers {
    libvirt = {
      source  = "erethon.com/third-party/libvirt"
      version = "0.6.2"
    }
  }
  required_version = ">= 0.13"
}
