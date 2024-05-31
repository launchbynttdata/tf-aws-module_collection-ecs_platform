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

module "ecs_platform" {
  source = "../.."

  # Need to inject route_table_ids for gateway endpoints
  gateway_vpc_endpoints   = var.gateway_vpc_endpoints
  interface_vpc_endpoints = var.interface_vpc_endpoints

  naming_prefix              = var.naming_prefix
  vpce_security_group        = var.vpce_security_group
  resource_names_map         = var.resource_names_map
  region                     = var.region
  environment                = var.environment
  environment_number         = var.environment_number
  resource_number            = var.resource_number
  container_insights_enabled = var.container_insights_enabled

  namespace_name        = var.namespace_name
  namespace_description = var.namespace_description

  tags = var.tags

  vpc_cidr                   = var.vpc_cidr
  private_subnet_cidr_ranges = var.private_subnet_cidr_ranges
  availability_zones         = var.availability_zones
  vpc_name                   = var.vpc_name
  create_vpc                 = var.create_vpc

}
