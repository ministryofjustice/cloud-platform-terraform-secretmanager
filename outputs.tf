output "irsa_policy_arn" {
  value       = aws_iam_policy.policy.arn
  description = "The policy arn that grants access to the secret."
}