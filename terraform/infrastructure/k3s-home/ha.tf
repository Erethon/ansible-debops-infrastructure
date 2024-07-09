resource "kubernetes_namespace" "ha" {
  metadata {
    name = "homeassistant"
  }
}

resource "kubernetes_pod" "ha" {
  metadata {
    name      = "homeassistant"
    namespace = kubernetes_namespace.ha.id
  }

  spec {
    container {
      image = "ghcr.io/home-assistant/home-assistant:2024.7"
      name  = "homeassistant"

      port {
        container_port = 8123
        host_port      = 8123
      }
      security_context {
        privileged = true
      }
      volume_mount {
        mount_path = "/config"
        name       = "haconfig"
        sub_path   = "config"
      }
    }
    volume {
      name = "haconfig"
      host_path {
        path = "/volumes/ha"
      }
    }
  }
}
