variable "domain" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "acme_email" {
  type = string
}

variable "http_basic_auth" {
  type      = string
  sensitive = true
}

variable "whitelisted_ips" {
  type      = list(string)
  sensitive = true
}

variable "chart_longhorn_version" {
  type = string
}

variable "chart_kured_version" {
  type = string
}

variable "chart_traefik_version" {
  type = string
}

variable "chart_cert_manager_version" {
  type = string
}
