output "security-group-ids" {
  value = aws_security_group.alb.*.id
}
