locals {
  irsa_serviceaccount_name = (var.irsa_serviceaccount_name != "" ? var.irsa_serviceaccount_name : "irsa-${var.namespace}")
}
module "secrets_manager" {
  source = "../"
  // source = "github.com/ministryofjustice/cloud-platform-terraform-secrets-manager?ref=1.1.0"
  team_name               = var.team_name
  application             = var.application
  business_unit           = var.business_unit
  is_production           = var.is_production
  namespace               = var.namespace
  environment             = var.environment
  infrastructure_support  = var.infrastructure_support
  serviceaccount_name = local.irsa_serviceaccount_name
  eks_cluster_name       = var.eks_cluster_name
  
  secrets = {
    "test-secret-01" = {
      description             = "test secret",
      recovery-window-in-days = 0
      k8s_secret_name        = "test-secret-01"
      k8s_secret_key = "test-secret-01-key"
    },
  }
}

// New users
module "irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=1.1.0"

  eks_cluster_name =  var.eks_cluster_name
  namespace        = var.namespace
  role_policy_arns = [module.secrets_manager.irsa_policy_arn]
  service_account = local.irsa_serviceaccount_name
}

resource "kubernetes_secret" "irsa" {
  metadata {
    name      = "irsa"
    namespace = var.namespace
  }
  data = {
    role           = module.irsa.aws_iam_role_name
    serviceaccount = local.irsa_serviceaccount_name
  }
}

// Existing users who have IRSA 
// Add "module.secrets_manager.irsa_policy_arn" to the role_policy_arns in the irsa module 
