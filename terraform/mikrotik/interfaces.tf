locals {
  pvids = {
    home  = 10,
    guest = 20,
    infra = 30,
    mgmt  = 99,
  }

  lan_bridged_interfaces = [
    {
      interface = routeros_interface_ethernet.ether1.name
      comment   = "PO"
      pvid      = [local.pvids.home]
    },
    {
      interface = routeros_interface_bonding.bonding_switch.name, # eth2 eth3
      comment   = "switch bonding trunk"
      pvid      = [local.pvids.guest, local.pvids.home, local.pvids.infra, local.pvids.mgmt]
    },
    #   {
    #     interface = routeros_interface_bonding.bonding_dl380.name # eth6 eth7
    #     comment   = "DL380 bonding trunk"
    #     pvid      = [local.pvids.infra] # FIXME: not used
    #   },
    # {
    #   interface = routeros_interface_ethernet.eth8.name
    #   comment   = "storage"
    #   pvid      = [local.pvids.infra] # FIXME: not used
    # },
  ]
}

### Physical ports

resource "routeros_interface_ethernet" "ether1" {
  factory_name = "ether1"
  name         = "ether1"
  disabled     = false
  comment      = "pc"
}

resource "routeros_interface_ethernet" "eth2" {
  factory_name = "ether2"
  name         = "ether2"
  disabled     = false
  comment      = "bonded interface, to switch"
}

resource "routeros_interface_ethernet" "eth3" {
  factory_name = "ether3"
  name         = "ether3"
  disabled     = false
  comment      = "bonded interface, to switch"
}

resource "routeros_interface_ethernet" "eth4" {
  factory_name = "ether4"
  name         = "ether4"
  disabled     = false
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
  disabled     = false
}

resource "routeros_interface_ethernet" "eth8" {
  factory_name = "ether8"
  name         = "ether8"
  disabled     = false
}

resource "routeros_interface_ethernet" "sfp" {
  factory_name               = "sfp-sfpplus1"
  name                       = "sfp-sfpplus1"
  disabled                   = false
  auto_negotiation           = false
  comment                    = "WAN - Orange"
  arp                        = "enabled"
  arp_timeout                = "auto"
  bandwidth                  = "unlimited/unlimited"
  l2mtu                      = 1514
  loop_protect               = "default"
  loop_protect_disable_time  = "5m"
  loop_protect_send_interval = "5s"
  mtu                        = 1500
  tx_flow_control            = "off"
  rx_flow_control            = "off"
  sfp_rate_select            = "high"
  sfp_shutdown_temperature   = 95
  speed                      = "2.5G-baseT"
}

### Virtual interfaces

resource "routeros_interface_bonding" "bonding_switch" {
  name      = "bonding-switch"
  slaves    = [routeros_interface_ethernet.eth2.name, routeros_interface_ethernet.eth3.name]
  lacp_mode = "active"
  mode      = "802.3ad"
}

# resource "routeros_interface_bonding" "bonding_dl380" {
#   name   = "bonding-dl380"
#   slaves = ["ether6", "ether7"]
#   # lacp_mode = "active"
#   mode = "balance-alb"
# }

### Bridge

resource "routeros_interface_bridge" "bridge_vlan" {
  name           = "bridge_lan"
  vlan_filtering = true
  frame_types    = "admit-only-vlan-tagged"
}

# All lan interfaces are bridged to lan bridge
resource "routeros_interface_bridge_port" "lan_bridged_interfaces" {
  for_each = {
    for idx, interface in local.lan_bridged_interfaces :
    interface.interface => interface
  }

  bridge    = routeros_interface_bridge.bridge_vlan.name
  interface = each.key

  pvid        = length(each.value.pvid) == 1 ? each.value.pvid[0] : 1
  frame_types = length(each.value.pvid) == 1 ? "admit-only-untagged-and-priority-tagged" : "admit-only-vlan-tagged"
}

### VLAN

resource "routeros_interface_vlan" "interface_vlan_home" {
  interface = routeros_interface_bridge.bridge_vlan.name
  name      = "vlan_home"
  vlan_id   = local.pvids.home
}

resource "routeros_interface_vlan" "interface_vlan_guest" {
  interface = routeros_interface_bridge.bridge_vlan.name
  name      = "vlan_guest"
  vlan_id   = local.pvids.guest
}

resource "routeros_interface_vlan" "interface_vlan_infra" {
  interface = routeros_interface_bridge.bridge_vlan.name
  name      = "vlan_infra"
  vlan_id   = local.pvids.infra
}

resource "routeros_interface_vlan" "interface_vlan_mgmt" {
  interface = routeros_interface_bridge.bridge_vlan.name
  name      = "vlan_mgmt"
  vlan_id   = local.pvids.mgmt
}
