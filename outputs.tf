output "irsa_policy_arn" {
  value       = aws_iam_policy.irsa_policy.arn
  description = "The policy arn that grants access to the secret."
}
output "secret_store_name" {
  value       = "${var.namespace}-secrets-store"
  description = "value of the secret store name"
}