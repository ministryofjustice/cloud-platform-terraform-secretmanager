#################
# Configuration #
#################
variable "eks_cluster_name" {
  description = "The name of the eks cluster to use a secret prefix"
  type        = string
}

variable "secrets" {
  type = map(object({
    description             = string
    recovery_window_in_days = number
    k8s_secret_name         = string
  }))
}

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}
