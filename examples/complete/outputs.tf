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

output "fargate_arn" {
  description = "The ARN of the ECS fargate cluster"
  value       = module.ecs_platform.fargate_arn
}

output "gateway_endpoints" {
  description = "A map of gateway VPC endpoint IDs"
  value       = module.ecs_platform.gateway_endpoints
}

output "interface_endpoints" {
  description = "A map of gateway VPC endpoint IDs"
  value       = module.ecs_platform.interface_endpoints
}

output "resource_names" {
  description = "A map of resource_name_types to generated resource names used in this module"
  value       = module.ecs_platform.resource_names
}

output "vpce_sg_id" {
  description = "The ID of the VPC Endpoint Security Group"
  value       = module.ecs_platform.vpce_sg_id
}

output "namespace_id" {
  description = "ID of the Cloud Map Namespace"
  value       = module.ecs_platform.namespace_id
}

output "namespace_arn" {
  description = "ARN of the Cloud Map Namespace"
  value       = module.ecs_platform.namespace_arn
}

output "namespace_hosted_zone" {
  description = "Hosted Zone of Cloud Map Namespace"
  value       = module.ecs_platform.namespace_hosted_zone
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.ecs_platform.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.ecs_platform.private_subnet_ids
}
