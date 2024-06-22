variable "domain" {
  type = string
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "pgsql_user" {
  type = string
}

variable "pgsql_password" {
  type      = string
  sensitive = true
}

variable "chart_redis_version" {
  type = string
}

variable "chart_cnpg_version" {
  type = string
}

variable "chart_pgadmin_version" {
  type = string
}

variable "chart_gitea_version" {
  type = string
}

variable "s3_endpoint" {
  type = string
}

variable "s3_region" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "s3_access_key" {
  type      = string
  sensitive = true
}

variable "s3_secret_key" {
  type      = string
  sensitive = true
}

variable "pgsql_recovery_target_time" {
  type    = string
  default = null
}

variable "pgadmin_email" {
  type    = string
  default = null
}

variable "pgadmin_password" {
  type    = string
  default = null
}

variable "gitea_admin_username" {
  type = string
}

variable "gitea_admin_password" {
  type      = string
  sensitive = true
}

variable "gitea_admin_email" {
  type = string
}

variable "gitea_db_password" {
  type      = string
  sensitive = true
}

variable "gitea_pvc_name" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_port" {
  type = string
}

variable "smtp_user" {
  type = string
}

variable "smtp_password" {
  type      = string
  sensitive = true
}
