resource "random_password" "vaultwarden-password" {
  length = 64
}

resource "vault_generic_secret" "vaultwarden-admin-creds" {
  path = "k8s-prrlvr-fr/vaultwarden/vaultwarden-admin-creds"
  data_json = jsonencode({
    token = random_password.forgejo-password.result
  })
}


