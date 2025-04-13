locals {
  gib = 1073741824
  nodes = {
    "cp_0" = {
      name     = "control_plane_0"
      hostname = "talos_cp_0"
      ip       = "10.0.40.110"
      type     = "cp"
    },
    "wk_0" = {
      name     = "worker_0"
      hostname = "talos_wk_0"
      ip       = "10.0.40.111"
      type     = "wk"
    },
    "wk_1" = {
      name     = "worker_1"
      hostname = "talos_cp_0"
      ip       = "10.0.40.112"
      type     = "wk"
    },
    "wk_2" = {
      name     = "worker_2"
      hostname = "talos_wk_2"
      ip       = "10.0.40.113"
      type     = "wk"
    },
  }
}

resource "xenorchestra_cloud_config" "k8s-talos-data" {
  name     = "cloud-config-data-omni"
  template = <<EOF
apiVersion: v1alpha1
kind: SideroLinkConfig
apiUrl: "https://omni.prrlvr.fr:8090/?jointoken=SMKHT6rQTfZRczLI7fZeFpIjXSPetZ0u0zpGI3x78xQB"
---
apiVersion: v1alpha1
kind: EventSinkConfig
endpoint: "[fdae:41e4:649b:9303::1]:8091"
---
apiVersion: v1alpha1
kind: KmsgLogConfig
name: omni-kmsg
url: "tcp://[fdae:41e4:649b:9303::1]:8092"
EOF
}

resource "xenorchestra_cloud_config" "k8s-talos-network" {
  for_each = local.nodes

  name     = "cloud-config-network-${each.value.name}"
  template = <<EOF
version: 1
config:
   - type: physical
     name: eth0
     subnets:
        - type: static
          address: ${each.value.ip}
          netmask: 255.255.255.0
          gateway: 10.0.40.1
          dns_nameservers:
             - 10.0.40.1
   - type: nameserver
     address:
        - 10.0.40.1
EOF
}

data "xenorchestra_template" "talos-cp" {
  name_label = "Talos Control Plane"
}

data "xenorchestra_template" "talos-wk" {
  name_label = "Talos Worker"
}

data "xenorchestra_network" "net1" {
  name_label = "Pool-wide network associated with eth1"
}

data "xenorchestra_sr" "local_storage" {
  name_label = "Local storage"
}

resource "xenorchestra_vm" "talos-k8s-node" {
  for_each = local.nodes

  cloud_config         = xenorchestra_cloud_config.k8s-talos-data.template
  cloud_network_config = xenorchestra_cloud_config.k8s-talos-network[each.key].template

  cpus         = each.value.type == "cp" ? 4 : 8
  memory_max   = (each.value.type == "cp" ? 6 : 16) * local.gib
  name_label   = "k8s_talos_${each.value.name}"
  auto_poweron = true
  power_state  = "Running"
  tags         = ["k8s", "talos"]

  template = (each.value.type == "cp"
    ? data.xenorchestra_template.talos-cp.id
  : data.xenorchestra_template.talos-wk.id)

  network {
    network_id = data.xenorchestra_network.net1.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "k8s_talos_${each.value.name}"
    size       = 20 * local.gib
    attached   = true
  }
}
