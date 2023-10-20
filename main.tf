// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

module "security_group_vpce" {
  count = var.vpce_security_group != null ? 1 : 0

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.1"

  vpc_id                   = data.aws_vpc.vpc.id
  name                     = module.resource_names["vpce_sg"].recommended_per_length_restriction
  description              = "Security Group for all VPC Endpoints"
  ingress_cidr_blocks      = coalesce(try(lookup(var.vpce_security_group, "ingress_cidr_blocks", []), []), [])
  ingress_rules            = coalesce(try(lookup(var.vpce_security_group, "ingress_rules", []), []), [])
  ingress_with_cidr_blocks = coalesce(try(lookup(var.vpce_security_group, "ingress_with_cidr_blocks", []), []), [])
  egress_cidr_blocks       = coalesce(try(lookup(var.vpce_security_group, "egress_cidr_blocks", []), []), [])
  egress_rules             = coalesce(try(lookup(var.vpce_security_group, "egress_rules", []), []), [])
  egress_with_cidr_blocks  = coalesce(try(lookup(var.vpce_security_group, "egress_with_cidr_blocks", []), []), [])

  tags = merge(local.tags, { resource_name = module.resource_names["vpce_sg"].standard })
}

module "resource_names" {
  source = "github.com/nexient-llc/tf-module-resource_name.git?ref=0.1.0"

  for_each = local.resource_names_map

  logical_product_name = var.naming_prefix
  region               = join("", split("-", var.region))
  class_env            = var.environment
  cloud_resource_type  = each.value.name
  instance_env         = var.environment_number
  instance_resource    = var.resource_number
  maximum_length       = each.value.max_length
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 4.1.3"

  cluster_name = module.resource_names["ecs_cluster"].recommended_per_length_restriction
  cluster_settings = {
    name  = "containerInsights"
    value = var.container_insights_enabled ? "enabled" : "disabled"
  }

  tags = merge(local.tags, { resource_name = module.resource_names["ecs_cluster"].standard })
}

module "interface_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.19.0"

  vpc_id             = data.aws_vpc.vpc.id
  security_group_ids = var.vpce_security_group != null ? [module.security_group_vpce[0].security_group_id] : []

  endpoints = {
    for k, v in var.interface_vpc_endpoints : k => {
      service             = v.service_name
      service_type        = "Interface"
      private_dns_enabled = v.private_dns_enabled
      subnet_ids          = concat(var.private_subnets, v.subnet_names)
      tags                = merge({ resource_name = try(module.resource_names[k].standard, k) }, v.tags)
    }
  }

  tags = local.tags
}

module "gateway_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.19.0"

  vpc_id             = data.aws_vpc.vpc.id
  security_group_ids = var.vpce_security_group != null ? [module.security_group_vpce[0].security_group_id] : []

  endpoints = {
    for k, v in var.gateway_vpc_endpoints : k => {
      service             = v.service_name
      service_type        = "Gateway"
      private_dns_enabled = v.private_dns_enabled
      subnet_ids          = concat(var.private_subnets, v.subnet_names)
      tags                = merge({ resource_name = try(module.resource_names[k].standard, k) }, v.tags)
      route_table_ids     = var.route_table_ids
    }
  }

  tags = local.tags
}

module "namespace" {
  source = "git::https://github.com/nexient-llc/tf-aws-module-private_dns_namespace.git?ref=0.1.0"

  count = length(var.namespace_name) > 0 ? 1 : 0

  name        = var.namespace_name
  description = length(var.namespace_description) > 0 ? var.namespace_description : "Cloud Map Namespace for ${var.naming_prefix}"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      Name : var.namespace_name
      resource_name : module.resource_names["namespace"].standard
    }
  )
}
