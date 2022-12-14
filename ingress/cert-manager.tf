resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  chart   = "jetstack/cert-manager"
  version = "v1.10.2"

  name      = "cert-manager"
  namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name

  set {
    name  = "prometheus.servicemonitor.enabled"
    value = true
  }
}

resource "helm_release" "cert_manager_webhook_hetzner" {
  chart   = "cert-manager-webhook-hetzner/cert-manager-webhook-hetzner"
  version = "1.1.0"

  name      = "cert-manager-webhook-hetzner"
  namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name

  set {
    name  = "groupName"
    value = var.cert_group_name
  }
}
