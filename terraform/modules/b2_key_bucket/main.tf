resource "b2_bucket" "bucket" {
  bucket_name = var.name
  bucket_type = "allPrivate"
}

resource "b2_application_key" "app_key" {
  capabilities = ["writeFiles", "readFiles", "listFiles"]
  key_name     = var.name
  bucket_id    = b2_bucket.bucket.bucket_id
}
