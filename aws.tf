terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      role = var.name
      Name = var.name
    }
  }
}

variable "region" {
  type = string
}

variable "name" {
  type        = string
  description = "environment name"
}
