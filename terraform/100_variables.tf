variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {}

variable "mongodb_allowed_prefix" {}

variable "bastion_allowed_prefix" {}

variable "s3_access_role_arn" {}
variable "s3_access_role_name" {}

variable "mongodb_backup_bucket" {}
