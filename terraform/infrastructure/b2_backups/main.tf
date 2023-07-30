resource "b2_bucket" "plothopes_wordpress" {
  bucket_name = "plothopes-wordpress"
  bucket_type = "allPrivate"
}

resource "b2_bucket" "plothopes_db" {
  bucket_name = "plothopes-db"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "plothopes_wordpress" {
  capabilities = ["writeFiles", "readFiles", "listFiles"]
  key_name = "plothopes-wordpress-key"
  bucket_id = b2_bucket.plothopes_wordpress.bucket_id
}

resource "b2_application_key" "plothopes_db" {
  capabilities = ["writeFiles", "readFiles", "listFiles"]
  key_name = "plothopes-db-key"
  bucket_id = b2_bucket.plothopes_db.bucket_id
}
