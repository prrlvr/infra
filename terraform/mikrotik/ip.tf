locals {
  dns_servers = ["8.8.8.8", "8.8.4.4"]
}

### TODO: refactor into a module

# Vlan ips

# resource "routeros_ip_address" "ip4_vlan_home" {
#   network   = "10.0.10.0"
#   address   = "10.0.10.1/24"
#   interface = routeros_interface_vlan.interface_vlan_home.name
# }
#
# resource "routeros_ip_address" "ip4_vlan_guest" {
#   network   = "10.0.20.0"
#   address   = "10.0.20.1/24"
#   interface = routeros_interface_vlan.interface_vlan_guest.name
# }
#
# resource "routeros_ip_address" "ip4_vlan_infra" {
#   network   = "10.0.30.0"
#   address   = "10.0.30.1/24"
#   interface = routeros_interface_vlan.interface_vlan_infra.name
# }
#
# resource "routeros_ip_address" "ip4_vlan_mgmt" {
#   network   = "10.0.99.0"
#   address   = "10.0.99.1/24"
#   interface = routeros_interface_vlan.interface_vlan_mgmt.name
# }

# DHCP ips pools

# resource "routeros_ip_pool" "ip4_pool_home" {
#   name   = "pool_home"
#   ranges = ["10.0.10.10-10.0.10.250"]
# }
#
# resource "routeros_ip_pool" "ip4_pool_guest" {
#   name   = "pool_guest"
#   ranges = ["10.0.20.10-10.0.20.250"]
# }
#
# # DHCP networks & servers
#
# resource "routeros_ip_dhcp_server_network" "ip4_dhcp_servernet_home" {
#   address    = "10.0.10.0/24"
#   gateway    = "10.0.10.1"
#   dns_server = local.dns_servers
# }
# resource "routeros_ip_dhcp_server" "ip4_dhcp_server_home" {
#   address_pool = routeros_ip_pool.ip4_pool_home.name
#   interface    = routeros_interface_vlan.interface_vlan_home.name
#   name         = "ip4_dhcp_home"
# }
#
# resource "routeros_ip_dhcp_server_network" "ip4_dhcp_servernet_guest" {
#   address    = "10.0.20.0/24"
#   gateway    = "10.0.20.1"
#   dns_server = local.dns_servers
# }
# resource "routeros_ip_dhcp_server" "ip4_dhcp_server_guest" {
#   address_pool = routeros_ip_pool.ip4_pool_guest.name
#   interface    = routeros_interface_vlan.interface_vlan_guest.name
#   name         = "ip4_dhcp_guest"
# }
