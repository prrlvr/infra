resource "random_password" "ilo-metrics-password" {
  length = 64
}

resource "vault_generic_secret" "ilo-metrics-creds" {
  path = "k8s-prrlvr-fr/observability/ilo-metrics-creds"
  data_json = jsonencode({
    username = "metrics_user"
    password = random_password.grafana-password.result
  })
}
