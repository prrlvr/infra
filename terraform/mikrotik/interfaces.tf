resource "routeros_interface_ethernet" "eth1" {
  factory_name = "ether1"
  name         = "ether1"
  disabled     = false
}

resource "routeros_interface_ethernet" "eth2" {
  factory_name = "ether2"
  name         = "ether2"
  disabled     = false
}

resource "routeros_interface_ethernet" "eth3" {
  factory_name = "ether3"
  name         = "ether3"
  disabled     = true
}

resource "routeros_interface_ethernet" "eth4" {
  factory_name = "ether4"
  name         = "ether4"
  disabled     = true
}

resource "routeros_interface_ethernet" "eth5" {
  factory_name = "ether5"
  name         = "ether5"
  disabled     = false
}

resource "routeros_interface_ethernet" "eth6" {
  factory_name = "ether6"
  name         = "ether6"
  disabled     = false
}

resource "routeros_interface_ethernet" "eth7" {
  factory_name = "ether7"
  name         = "ether7"
  disabled     = true
}

resource "routeros_interface_ethernet" "eth8" {
  factory_name = "ether8"
  name         = "ether8"
  disabled     = false
}

resource "routeros_interface_ethernet" "sfp" {
  factory_name = "sfp-sfpplus1"
  name         = "sfp"
  disabled     = false
}

resource "routeros_interface_vlan" "interface_vlan_home" {
  interface = "bridge"
  name      = "VLAN_HOME"
  vlan_id   = 10
}

resource "routeros_interface_vlan" "interface_vlan_guest" {
  interface = "bridge"
  name      = "VLAN_GUEST"
  vlan_id   = 20
}

resource "routeros_interface_vlan" "interface_vlan_infra" {
  interface = "bridge"
  name      = "VLAN_INFRA"
  vlan_id   = 30
}

resource "routeros_interface_vlan" "interface_vlan_mgmt" {
  interface = "bridge"
  name      = "VLAN_MGMT"
  vlan_id   = 99
}
