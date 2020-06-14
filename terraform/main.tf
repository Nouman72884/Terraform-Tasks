module "securitygroups" {
  source = "./modules/securitygroups"
  name_prefix = var.name_prefix
  cidr = var.cidr
  ports = var.ports
  alb_rules_limit = var.alb_rules_limit
  vpc_id = var.vpc_id
 }

