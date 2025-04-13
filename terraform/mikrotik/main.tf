terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }

  backend "s3" {
    bucket                      = "s3-infra-backup"
    key                         = "infra-mikrotik.tfstate"
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
  hosturl = "http://router.lan" # env ROS_HOSTURL or MIKROTIK_HOST
  # ca_certificate = "./cert"                      # env ROS_CA_CERTIFICATE or MIKROTIK_CA_CERTIFICATE
  insecure = true
}

resource "routeros_ip_address" "addr_infra_subnet" {
  address   = "10.0.40.1/24"
  interface = routeros_interface_ethernet.eth8.name
  network   = "10.0.40.0"
}

resource "routeros_ip_pool" "pool_infra" {
  name   = "pool_infra"
  ranges = ["10.0.40.200-10.0.40.250"]
}

resource "routeros_ip_dhcp_server_network" "net_infra" {
  address    = "10.0.40.0/24"
  gateway    = "10.0.40.1"
  dns_server = ["10.0.40.1"]
}

resource "routeros_ip_dhcp_server" "infra_ip4_dhcp_server" {
  address_pool = routeros_ip_pool.pool_infra.name
  interface    = routeros_ip_address.addr_infra_subnet.interface
  name         = "ip4_infra_dhcp"
}

resource "routeros_ip_firewall_nat" "k3s_ingress_rule_tls" {
  action            = "dst-nat"
  chain             = "dstnat"
  in_interface_list = "WAN"
  protocol          = 6
  port              = "444"
  to_addresses      = "10.0.40.20"
  to_ports          = "443"
}

resource "routeros_ip_firewall_nat" "resolve_hairpin_nat" {
  action      = "masquerade"
  chain       = "srcnat"
  dst_address = "10.0.40.20"
  protocol    = 6
  src_address = "192.168.1.0/24"
}

