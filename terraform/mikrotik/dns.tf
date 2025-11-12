# resource "routeros_ip_dns_record" "truenas" {
#   name    = "truenas.local"
#   address = "10.0.40.9"
#   type    = "A"
# }

# resource "routeros_ip_dns_record" "xcp-ng" {
#   name    = "xcp.local"
#   address = "10.0.40.10"
#   type    = "A"
# }

resource "routeros_ip_dns_record" "ubiquiti_switch" {
  name    = "edgeswitch.local"
  address = "192.168.1.2"
  type    = "A"
}

# resource "routeros_ip_dns_record" "xoa" {
#   name    = "xoa.local"
#   address = "10.0.40.205"
#   type    = "A"
# }

resource "routeros_ip_dns_record" "pi_dns" {
  name    = "pi-dns.local"
  address = "10.0.30.5"
  type    = "A"
}
