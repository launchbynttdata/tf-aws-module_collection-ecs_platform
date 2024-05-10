# This tfvars can be used for testing with the module in examples/complete.

naming_prefix = "terratest"

interface_vpc_endpoints = {
  ecrdkr = {
    service_name        = "ecr.dkr"
    private_dns_enabled = true
  }
  ecrapi = {
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

vpce_security_group = {
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [{
    cidr_blocks = "10.70.134.0/23"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    },
    {
      cidr_blocks = "10.63.32.0/23"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
    {
      cidr_blocks = "10.63.30.0/24"
      from_port   = 27017
      to_port     = 27018
      protocol    = "tcp"
  }]
}

namespace_name = "test.example.com"
