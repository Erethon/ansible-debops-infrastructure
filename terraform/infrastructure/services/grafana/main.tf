provider "grafana" {
  url = var.url
}

resource "grafana_data_source" "prometheus" {
  type       = "prometheus"
  name       = "defaultPrometheus"
  url        = "http://127.0.0.1:9090"
  is_default = true
}
