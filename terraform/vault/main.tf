terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }

  backend "s3" {
    bucket                      = "s3-infra-backup"
    key                         = "infra-vault.tfstate"
    region                      = "eu-west-par"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    endpoints = {
      s3 = "https://s3.eu-west-par.io.cloud.ovh.net"
    }
  }
}

locals {
  sa_name   = "external-secrets-vault"
  namespace = "external-secrets"
}

provider "vault" {
  address = "https://vault.k8s.prrlvr.fr"
}

provider "kubernetes" {
  alias          = "k8s-prrlvr-fr"
  config_path    = "~/.kube/config"
  config_context = "omni-k8s.prrlvr.fr"
}
