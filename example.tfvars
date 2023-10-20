# User needs to populate all the fields in <> in order to use this with `terraform plan|apply`

vpc_id          = "<vpc_id>"
private_subnets = ["<comma separated subnet_ids>"]

interface_vpc_endpoints = {
  ecr-dkr = {
    service_name        = "ecr.dkr"
    private_dns_enabled = true
  }
  ecr-api = {
    service_name        = "ecr.api"
    private_dns_enabled = true
  }
  ecs = {
    service_name        = "ecs"
    private_dns_enabled = true
  }
  logs = {
    service_name        = "logs"
    private_dns_enabled = true
  }
}

gateway_vpc_endpoints = {
  s3 = {
    service_name        = "s3"
    private_dns_enabled = true
  }
}

route_table_ids = [
  "<comma separated route_table ids>"
]

# Ingress/Egress rules can be found at https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
vpce_security_group = {
  # would all 443 and 80 tc from everywhere
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # would allow egress all ports are open to everywhere
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
