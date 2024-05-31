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

locals {

  default_tags = {
    provisioner = "Terraform"
  }

  all_vpc_endpoints = merge(var.interface_vpc_endpoints, var.gateway_vpc_endpoints)

  vpce_names_map = length(local.all_vpc_endpoints) > 0 ? { for k, v in local.all_vpc_endpoints : k => { name : k, max_length : 60 } } : {}

  resource_names_map = merge(local.vpce_names_map, var.resource_names_map)

  tags = merge(local.default_tags, var.tags)

  vpc_id          = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  private_subnets = var.create_vpc ? module.vpc[0].private_subnets : var.private_subnets
  route_table_ids = var.create_vpc ? concat([module.vpc[0].default_route_table_id], module.vpc[0].private_route_table_ids) : var.route_table_ids
}
