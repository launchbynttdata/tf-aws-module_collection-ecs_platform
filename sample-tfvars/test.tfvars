# This tfvars file creates a VPC with 2 public and 3 private subnets in us-east-2 region.
# It also creates VPC endpoints for ECR, ECS, CloudWatch Logs and S3.

logical_product_family  = "demo1"
logical_product_service = "ecs_ptfrm"
environment             = "sandbox"
region                  = "us-east-2"
environment_number      = "000"

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
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

namespace_name = "demo1.example.com"

resource_names_map = {
  ecs_cluster = {
    name       = "fargate"
    max_length = 60
  }
  vpce_sg = {
    name       = "vpcesg"
    max_length = 60
  }
  namespace = {
    name       = "ns"
    max_length = 60
  }
}

vpc = {
  vpc_name                   = "www-vpc"
  vpc_cidr                   = "10.2.0.0/16"
  private_subnet_cidr_ranges = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnet_cidr_ranges  = ["10.2.4.0/24", "10.2.5.0/24"]
  availability_zones         = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

create_vpc = true
