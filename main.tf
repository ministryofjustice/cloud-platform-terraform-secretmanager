data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

<<<<<<< HEAD
=======
locals {
  default_tags = {
    business-unit          = var.business_unit
    application            = var.application
    is-production          = var.is_production
    environment-name       = var.environment
    owner                  = var.team_name
    infrastructure-support = var.infrastructure_support
    namespace              = var.namespace
  }
  secret_store_name = "${var.namespace}-secrets-store"

}

>>>>>>> acd3184f5c42b7c28fcbaaed4be1b26dd6b15ce0
resource "aws_secretsmanager_secret" "secret" {
  for_each                = { for k, v in var.secrets : k => v }
  description             = each.value.description != "" ? each.value.description : "Secret for ${each.value.name}"
  name                    = "${var.namespace}/${each.value.name}"
  recovery_window_in_days = each.value.recovery-window-in-days # Set to 0 for no protection, between 7-30 days protection, default is 30.
  tags = local.default_tags

}


data "aws_iam_policy_document" "irsa_policy" {
  statement {
    sid    = "Stmt1682592071960"
    effect = "Allow"

    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret" ]
     resources = [ "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.namespace}/*" ]
  }
  statement {
    sid    = "Stmt1682592056675"
    effect = "Allow"

    actions   = ["secretsmanager:ListSecrets" ]
     resources = [ "*" ]
  }
}

<<<<<<< HEAD
resource "aws_iam_policy" "policy" {
  for_each    = { for k, v in var.secrets : k => v }
  name        = "${each.value.namespace}-policy-for-${each.value.name}-secret"
  path        = "/"
  description = "This policy is created to access the ${each.value.name} secret for the ${each.value.namespace} namespace."
=======
resource "aws_iam_policy" "irsa_policy" {
  name        = "irsa-policy-to-access-secrets"
  path        = "/${var.namespace}/"
  policy      = data.aws_iam_policy_document.irsa_policy.json
  description = "Policy for accessing secrets via IRSA"
}
>>>>>>> acd3184f5c42b7c28fcbaaed4be1b26dd6b15ce0

resource "kubernetes_manifest" "secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1alpha1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = local.secret_store_name
      "namespace" = var.namespace
      "labels"    = {
        "managed/by": "terraform"
      }
    }
    "spec" = {
      "provider" = {
        "aws": {
          "service": "SecretsManager"
          "region": data.aws_region.current.name
          "auth": {
            "jwt": {
              "serviceAccountRef": {
                "name": var.serviceaccount_name
              }
            }
          }
        }
      }
    }
  }
}

