locals {
  users = [
    "forgejo"
  ]
}

resource "random_password" "postgres-password" {
  for_each = toset(local.users)

  length  = 32
  special = false
}

resource "vault_generic_secret" "postgres-user" {
  for_each = toset(local.users)

  path = "k8s-prrlvr-fr/postgres/users/${each.value}"
  data_json = jsonencode({
    username = each.value
    password = random_password.postgres-password[each.value].result
  })
}

resource "random_password" "pgadmin-password" {
  length  = 32
  special = false
}

resource "vault_generic_secret" "pgadmin" {
  path = "k8s-prrlvr-fr/pgadmin/pgadmin"
  data_json = jsonencode({
    username = "admin@prrlvr.fr"
    password = random_password.pgadmin-password.result
  })
}

resource "random_password" "postgres-superuser-password" {
  length  = 32
  special = false
}

resource "vault_generic_secret" "postgres-superuser" {
  path = "k8s-prrlvr-fr/postgres/superuser"
  data_json = jsonencode({
    username = "superuser"
    password = random_password.postgres-superuser-password.result
  })
}
