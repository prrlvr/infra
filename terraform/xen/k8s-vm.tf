locals {
  gib   = 1073741824
  hosts = ["tkcenter-0", "tkcenter-1", "tkcenter-2"]
  nodes = {
    "cp_0" = {
      name     = "control_plane_0"
      hostname = "talos_cp_0"
      type     = "cp"
      host     = "tkcenter-0"
      mac      = "ee:79:a8:13:8b:00"
    },
    "wk_0" = {
      name     = "worker_0"
      hostname = "talos_wk_0"
      type     = "wk"
      host     = "tkcenter-1"
      mac      = "ee:79:a8:13:8b:01"
    },
    "wk_1" = {
      name     = "worker_1"
      hostname = "talos_wk_1"
      type     = "wk"
      host     = "tkcenter-2"
      mac      = "ee:79:a8:13:8b:02"
    },
    "wk_2" = {
      name     = "worker_2"
      hostname = "talos_wk_2"
      type     = "wk"
      host     = "tkcenter-2"
      mac      = "ee:79:a8:13:8b:03"
    },
    "cp_1" = {
      name     = "control_plane_1"
      hostname = "talos_cp_1"
      type     = "cp"
      host     = "tkcenter-2"
      mac      = "ee:79:a8:13:8b:04"
    },
  }
}

data "xenorchestra_template" "talos" {
  name_label = "Talos Node"
}

data "xenorchestra_network" "net1" {
  name_label = "Pool-wide network associated with eth0"
}

data "xenorchestra_sr" "local_hosts_storages" {
  for_each   = toset(local.hosts)
  name_label = "Local storage"
  tags       = [each.key]
}

resource "xenorchestra_vm" "talos-k8s-node" {
  for_each = local.nodes

  cpus         = each.value.type == "cp" ? 4 : 4
  memory_max   = (each.value.type == "cp" ? 4 : 6) * local.gib
  name_label   = "k8s_talos_${each.value.name}"
  auto_poweron = true
  power_state  = "Running"
  tags         = ["k8s", "talos"]

  template = data.xenorchestra_template.talos.id

  network {
    network_id  = data.xenorchestra_network.net1.id
    mac_address = each.value.mac
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_hosts_storages[each.value.host].id
    name_label = "k8s_talos_${each.value.name}"
    size       = 30 * local.gib
    attached   = true
  }
}
