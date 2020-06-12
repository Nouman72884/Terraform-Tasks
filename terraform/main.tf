module "securitygroups" {
  source = "./modules/securitygroups"
  add_https_rules = var.add_https_rules
 }

