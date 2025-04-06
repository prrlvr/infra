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
