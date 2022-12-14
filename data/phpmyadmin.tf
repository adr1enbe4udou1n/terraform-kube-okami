resource "kubernetes_deployment_v1" "phpmyadmin" {
  metadata {
    name      = "phpmyadmin"
    namespace = kubernetes_namespace_v1.mysql.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        app = "phpmyadmin"
      }
    }
    template {
      metadata {
        labels = {
          app = "phpmyadmin"
        }
      }
      spec {
        container {
          name  = "phpmyadmin"
          image = "phpmyadmin/phpmyadmin"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_secret.metadata[0].name
                key  = "mysql-root-password"
              }
            }
          }

          env {
            name  = "PMA_HOST"
            value = kubernetes_service_v1.mysql.metadata[0].name
          }

          env {
            name  = "UPLOAD_LIMIT"
            value = "100M"
          }

          port {
            container_port = 80
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            timeout_seconds       = 1
          }
        }

        toleration {
          key      = "node-role.kubernetes.io/data"
          operator = "Exists"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "phpmyadmin" {
  metadata {
    name      = "phpmyadmin"
    namespace = kubernetes_namespace_v1.mysql.metadata[0].name
  }
  spec {
    selector = {
      app = "phpmyadmin"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_manifest" "phpmyadmin" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "phpmyadmin"
      namespace = kubernetes_namespace_v1.mysql.metadata[0].name
    }
    spec = {
      entryPoints = [
        "websecure",
      ]
      routes = [
        {
          match = "Host(`pma.${var.domain}`)"
          kind  = "Rule"
          middlewares = [
            {
              namespace = "traefik"
              name      = "middleware-ip"
            }
          ]
          services = [
            {
              kind = "Service"
              name = kubernetes_service_v1.phpmyadmin.metadata[0].name
              port = 80
            },
          ]
        },
      ]
    }
  }
}
