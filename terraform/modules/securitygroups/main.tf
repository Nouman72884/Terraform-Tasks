resource "aws_security_group" "alb" {
  count = local.chunks_length <= 5 ? local.chunks_length : 5
  name_prefix = "alb.${terraform.workspace}.${var.environment}"
  description = "allow http and https for alb"
  vpc_id      = "vpc-a0eeacda"
  dynamic "ingress" {
    for_each = var.add_https_rules == "true" ? local.chunks[count.index] : []
    content {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = [ingress.value]
      description = local.trans[ingress.value][0]
    }
  }
  dynamic "ingress" {
    for_each = local.chunks[count.index]
    content {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = [ingress.value]
      description = local.trans[ingress.value][0]
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

locals {
  allcidr = values(var.CIDR)
  all = flatten(local.allcidr)
  trans = transpose(var.CIDR)
  chunks = chunklist(local.all, 25)
  chunks_length = length(local.chunks)
}

