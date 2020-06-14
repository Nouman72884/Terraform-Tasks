

variable "name_prefix" {
  default= ""
}
variable "cidr" {
    default = {}
}
variable "ports" {
  type    = "list"
  default = []
}
variable "alb_rules_limit" {
  default = 50
}
variable "vpc_id" {
  default = ""
}
 
