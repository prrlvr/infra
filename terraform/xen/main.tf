terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
    }
  }

  backend "s3" {
    bucket                      = "s3-infra-backup"
    key                         = "infra-xen.tfstate"
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

provider "xenorchestra" {
  url      = "ws://xoa.local"  # Or set XOA_URL environment variable
  username = "admin@prrlvr.fr" # Or set XOA_USER environment variable
  insecure = true
}

data "xenorchestra_network" "net" {
  name_label = "Pool-wide network associated with eth0"
}
