# This tfvars can be used for testing with the module in examples/complete.

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
  ingress_rules           = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  egress_with_cidr_blocks = []
}

namespace_name = "test.example.com"
create_vpc     = true

vpc = {
  vpc_name                   = "test-vpc-ecr"
  vpc_cidr                   = "10.2.0.0/16"
  private_subnet_cidr_ranges = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  availability_zones         = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
