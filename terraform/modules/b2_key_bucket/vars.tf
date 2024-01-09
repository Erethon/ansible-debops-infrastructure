variable "name" {
  type = string
}

variable "bucket_type" {
  type    = string
  default = "allPrivate"
}

variable "key_capabilities" {
  type    = list(string)
  default = ["writeFiles", "readFiles", "listFiles"]
}
