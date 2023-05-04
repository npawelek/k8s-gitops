terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

variable "AWS_DOMAIN" {
  type        = string
  description = "Use the defined domain within TF_VAR_AWS_DOMAIN environment variable"
}

variable "AWS_KMS_ARN" {
  type        = string
  description = "Use the defined KMS ARN within TF_VAR_AWS_KMS_ARN environment variable"
}

variable "AWS_S3_BUCKET" {
  type        = string
  description = "Use the defined S3 bucket within TF_VAR_AWS_S3_BUCKET environment variable"
}

variable "AWS_S3_KEY" {
  type        = string
  description = "Use the defined S3 object key within TF_VAR_AWS_S3_KEY environment variable"
}

provider "aws" {}

data "aws_route53_zone" "domain" {
  name = var.AWS_DOMAIN
}

data "http" "ipv4" {
  url = "http://checkip.amazonaws.com"
}

resource "aws_route53_record" "vpn" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "vpn"
  type    = "A"
  ttl     = 300
  records = [chomp(data.http.ipv4.response_body)]
}

resource "aws_route53_record" "video" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "video"
  type    = "A"
  ttl     = 300
  records = [chomp(data.http.ipv4.response_body)]
}

resource "aws_route53_record" "req" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "req"
  type    = "A"
  ttl     = 300
  records = [chomp(data.http.ipv4.response_body)]
}
