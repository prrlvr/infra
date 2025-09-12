# WAN Configuration

### DHCP WAN

locals {
  dhcp_client_options = {
    60 = {
      name  = "vendor-class-identifier"
      value = "0x736167656d"
    }
    77 = {
      name  = "userclass"
      value = "0x2b46535644534c5f6c697665626f782e496e7465726e65742e736f66746174686f6d652e4c697665626f7836"
    }
    90 = {
      name  = "authsend"
      value = "0x00000000000000000000001a0900000558010341010D6674692F623277616332683c1231323334353637383930313233343536031341ac4dce375bc81d302c926a9b16eff239"
    }
  }

  dhcpv6_client_options = {
    16 = {
      name  = "vendor-class-identifier"
      value = "0x736167656d"
    }
    15 = {
      name  = "userclass"
      value = "0x2b46535644534c5f6c697665626f782e496e7465726e65742e736f66746174686f6d652e4c697665626f7836"
    }
    11 = {
      name  = "authsend"
      value = "0x00000000000000000000001a0900000558010341010D6674692F623277616332683c1231323334353637383930313233343536031341ac4dce375bc81d302c926a9b16eff239"
    }
  }

  orange_mac = "2C:93:FB:D8:34:A0"
}

resource "routeros_dhcp_client_option" "dhcp_client_options" {
  for_each = local.dhcp_client_options
  code     = each.key
  name     = each.value.name
  value    = each.value.value
}

resource "routeros_ipv6_dhcp_client_option" "dhcpv6_client_options" {
  for_each = local.dhcpv6_client_options
  code     = each.key
  name     = each.value.name
  value    = each.value.value
}

# ONT - Orange VLAN
resource "routeros_interface_vlan" "interface_vlan_ont" {
  interface                  = routeros_interface_ethernet.sfp.name
  name                       = "vlan_ont"
  vlan_id                    = 832
  comment                    = "internet ont"
  loop_protect_disable_time  = "0s"
  loop_protect_send_interval = "1s"
}


resource "routeros_ip_dhcp_client" "wan_dhcp_client" {
  interface         = routeros_interface_vlan.interface_vlan_ont.name
  disabled          = false
  add_default_route = "yes"
  dhcp_options      = "hostname,clientid,authsend,userclass,vendor-class-identifier"
  use_peer_dns      = false
}

# resource "routeros_ipv6_dhcp_client" "wan_dhcp_v6_client" {
#   interface         = routeros_interface_bridge.bridge_wan.name
#   disabled          = false
#   add_default_route =  true
#   # dhcp_options      = ["hostname","clientid","authsend","userclass","vendor-class-identifier"]
#   use_peer_dns      = false
#   pool_prefix_length = 64
#   request            = ["prefix"]
# }
