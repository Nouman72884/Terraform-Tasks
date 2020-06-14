locals {
  all_cidr = values(var.cidr)
  all_ip = flatten(local.all_cidr)
  trans = transpose(var.cidr)
  product = setproduct(flatten(local.all_ip), var.ports)
  group_data = [
    for pair in local.product: {
      CIDR: pair[0], 
      PORT: pair[1], 
      NAME: local.trans[pair[0]][0] 
    }
  ]
  total_rules = length(local.group_data)
  chunks = chunklist(local.group_data,var.alb_rules_limit)
  chunks_nested = [
    for pairs in local.chunks: [
      for pair in pairs: [{
        CIDR: pair["CIDR"], PORT: pair["PORT"], NAME: pair["NAME"]
      }]
    ]
  ]
}

resource "aws_security_group" "sg" {
  count = length(local.chunks_nested)
  name_prefix = var.name_prefix
  description = "allow http and https for alb"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = local.chunks_nested[count.index]
    content {
      from_port = ingress.value[0]["PORT"]
      to_port   = ingress.value[0]["PORT"]
      protocol  = "tcp"
      cidr_blocks = [ingress.value[0]["CIDR"]]
      description = ingress.value[0]["NAME"]
    }
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
  lifecycle {
      ignore_changes = [
        name, name_prefix
      ]
    }
}


