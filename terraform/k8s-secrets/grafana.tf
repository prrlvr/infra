resource "random_password" "grafana-password" {
  length = 64
}

resource "vault_generic_secret" "grafana-admin-creds" {
  path = "k8s-prrlvr-fr/grafana/grafana-admin-creds"
  data_json = jsonencode({
    username = "admin"
    password = random_password.grafana-password.result
  })
}


