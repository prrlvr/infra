resource "random_password" "forgejo-password" {
  length = 64
}

resource "vault_generic_secret" "forgejo-admin-creds" {
  path = "k8s-prrlvr-fr/forgejo/forgejo-admin-creds"
  data_json = jsonencode({
    username = "admin-forgejo"
    email    = "admin@prrlvr.fr"
    password = random_password.forgejo-password.result
  })
}

