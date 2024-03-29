resource "kubernetes_namespace_v1" "concourse" {
  metadata {
    name = "concourse"
  }
}

resource "helm_release" "concourse" {
  chart      = "concourse"
  version    = var.chart_concourse_version
  repository = "https://concourse-charts.storage.googleapis.com"

  name      = "concourse"
  namespace = kubernetes_namespace_v1.concourse.metadata[0].name

  values = [
    file("${path.module}/values/concourse-values.yaml")
  ]

  set {
    name  = "concourse.web.externalUrl"
    value = "https://concourse.int.${var.domain}"
  }

  set {
    name  = "concourse.web.auth.mainTeam.localUser"
    value = var.concourse_user
  }

  set {
    name  = "secrets.postgresPassword"
    value = var.concourse_db_password
  }

  set {
    name  = "secrets.localUsers"
    value = "${var.concourse_user}:${var.concourse_password}"
  }
}

resource "kubernetes_manifest" "concourse_ingress" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "concourse"
      namespace = kubernetes_namespace_v1.concourse.metadata[0].name
    }
    spec = {
      entryPoints = ["internal"]
      routes = [
        {
          match = "Host(`concourse.int.${var.domain}`)"
          kind  = "Rule"
          services = [
            {
              name = "concourse-web"
              port = "atc"
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_secret_v1" "concourse_registry" {
  metadata {
    name      = "registry"
    namespace = "concourse-main"
  }

  data = {
    name     = "gitea.int.${var.domain}"
    username = var.concourse_git_username
    password = var.concourse_git_password
  }

  depends_on = [
    helm_release.concourse
  ]
}

resource "kubernetes_secret_v1" "concourse_git" {
  metadata {
    name      = "git"
    namespace = "concourse-main"
  }

  data = {
    username       = var.concourse_git_username
    password       = var.concourse_git_password
    git-user       = "Concourse CI <concourse@okami101.io>"
    commit-message = "bump to %version% [ci skip]"
  }

  depends_on = [
    helm_release.concourse
  ]
}

resource "kubernetes_secret_v1" "concourse_sonarqube" {
  metadata {
    name      = "sonarqube"
    namespace = "concourse-main"
  }

  data = {
    url            = "http://sonarqube-sonarqube.sonarqube:9000"
    analysis-token = var.concourse_analysis_token
  }

  depends_on = [
    helm_release.concourse
  ]
}
