resource "vault_auth_backend" "kubernetes-k8s-prrlvr-fr" {
  type = "kubernetes"
  path = "k8s-prrlvr-fr"
}

resource "kubernetes_service_account" "external-secrets-vault-k8s-prrlvr-fr" {
  provider = kubernetes.k8s-prrlvr-fr
  metadata {
    name      = local.sa_name
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role_binding" "external-secrets-vault-k8s-prrlvr-fr" {
  provider = kubernetes.k8s-prrlvr-fr
  metadata {
    name = local.sa_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.sa_name
    namespace = local.namespace
  }
}

resource "kubernetes_secret_v1" "external-secrets-vault-k8s-prrlvr-fr" {
  provider = kubernetes.k8s-prrlvr-fr
  metadata {
    name      = local.sa_name
    namespace = local.namespace
    annotations = {
      "kubernetes.io/service-account.name" = local.sa_name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes-k8s-prrlvr-fr" {
  backend              = vault_auth_backend.kubernetes-k8s-prrlvr-fr.path
  kubernetes_host      = "https://kubernetes.default.svc"
  kubernetes_ca_cert   = kubernetes_secret_v1.external-secrets-vault-k8s-prrlvr-fr.data["ca.crt"]
  token_reviewer_jwt   = kubernetes_secret_v1.external-secrets-vault-k8s-prrlvr-fr.data["token"]
  disable_local_ca_jwt = true
}

resource "vault_policy" "external-secrets-vault-k8s-prrlvr-fr" {
  name   = "external-secrets-vault-k8s-prrlvr-fr"
  policy = <<EOT
path "k8s-prrlvr-fr/data/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "external-secrets-vault-k8s-prrlvr-fr" {
  backend                          = vault_auth_backend.kubernetes-k8s-prrlvr-fr.path
  role_name                        = "k8s-prrlvr-fr-external-secrets"
  bound_service_account_names      = [local.sa_name]
  bound_service_account_namespaces = [local.namespace]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.external-secrets-vault-k8s-prrlvr-fr.name]
  token_no_default_policy          = false
}

resource "vault_mount" "k8s-prrlvr-fr-kvv2" {
  path    = "k8s-prrlvr-fr"
  type    = "kv"
  options = { version = "2" }
}

resource "vault_kv_secret_backend_v2" "k8s-prrlvr-fr" {
  mount        = vault_mount.k8s-prrlvr-fr-kvv2.path
  max_versions = 10
  cas_required = false
}
