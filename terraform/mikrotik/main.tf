terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.88.0"
    }
  }

  backend "s3" {
    bucket                      = "s3-infra-backup"
    key                         = "rb5009.tfstate"
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

provider "routeros" {
  hosturl = "http://192.168.88.1" # env ROS_HOSTURL or MIKROTIK_HOST
  # ca_certificate = "./cert"                      # env ROS_CA_CERTIFICATE or MIKROTIK_CA_CERTIFICATE
  insecure = true
}

# resource "routeros_ip_firewall_nat" "k3s_ingress_rule_tls" {
#   action            = "dst-nat"
#   chain             = "dstnat"
#   in_interface_list = "WAN"
#   protocol          = 6
#   port              = "444"
#   to_addresses      = "10.0.40.20"
#   to_ports          = "443"
# }
#
# resource "routeros_ip_firewall_nat" "resolve_hairpin_nat" {
#   action      = "masquerade"
#   chain       = "srcnat"
#   dst_address = "10.0.40.20"
#   protocol    = 6
#   src_address = "192.168.1.0/24"
# }
#
