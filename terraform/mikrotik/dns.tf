resource "routeros_ip_dns_record" "dl380g9_0_ilo4" {
  name    = "g9-0-ilo4.local"
  address = "10.0.40.201"
  type    = "A"
}

resource "routeros_ip_dns_record" "truenas" {
  name    = "truenas.local"
  address = "10.0.40.9"
  type    = "A"
}

resource "routeros_ip_dns_record" "xcp-ng" {
  name    = "xcp.local"
  address = "10.0.40.10"
  type    = "A"
}

resource "routeros_ip_dns_record" "ubiquiti_switch" {
  name    = "ubiquiti_edgewitch.local"
  address = "10.0.40.200"
  type    = "A"
}

resource "routeros_ip_dns_record" "xoa" {
  name    = "xoa.local"
  address = "10.0.40.205"
  type    = "A"
}
