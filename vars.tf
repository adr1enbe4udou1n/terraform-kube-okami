variable "domain" {
  type = string
}

variable "whitelisted_ips" {
  type = list(string)
}

variable "nfs_server" {
  type = string
}

variable "nfs_path" {
  type = string
}

variable "cert_group_name" {
  type = string
}

variable "hetzner_dns_api_key" {
  type = string
}

variable "acme_email" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "basic_http_auth" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_user" {
  type = string
}

variable "smtp_password" {
  type = string
}

variable "mysql_password" {
  type = string
}

variable "pgsql_password" {
  type = string
}
