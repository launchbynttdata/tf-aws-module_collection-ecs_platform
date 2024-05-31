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

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "platform"
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "ecs"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  default     = "000"
  type        = string
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  default     = "000"
  type        = string
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
  type        = string
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    ecs_cluster = {
      name       = "fargate"
      max_length = 60
    }
    vpce_sg = {
      name       = "vpce-sg"
      max_length = 60
    }
    namespace = {
      name       = "ns"
      max_length = 60
    }
  }
}

### VPC related variables
variable "vpc_id" {
  description = "The VPC ID of the VPC where infrastructure will be provisioned"
  type        = string
  default     = null
}

variable "vpc_name" {
  type    = string
  default = "test-vpc-015935234"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "private_subnet_cidr_ranges" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "create_vpc" {
  description = "Whether to create the VPC or not"
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = []
}


### VPC Endpoints related variables
variable "gateway_vpc_endpoints" {
  description = "List of VPC endpoints to be created. AWS currently only supports S3 and DynamoDB gateway interfaces"
  type = map(object({
    service_name        = string
    subnet_names        = optional(list(string), [])
    private_dns_enabled = optional(bool, false)
    route_table_ids     = optional(list(string))
    tags                = optional(map(string), {})
  }))

  default = {}
}

variable "interface_vpc_endpoints" {
  description = "List of VPC endpoints to be created"
  type = map(object({
    service_name        = string
    subnet_names        = optional(list(string), [])
    private_dns_enabled = optional(bool, false)
    tags                = optional(map(string), {})
  }))

  default = {}
}

variable "route_table_ids" {
  description = "List of route tables for Gateway VPC endpoints"
  type        = list(string)
  default     = []
}

variable "vpce_security_group" {
  description = "Default security group to be attached to all VPC endpoints"
  type = object({
    ingress_rules            = optional(list(string))
    ingress_cidr_blocks      = optional(list(string))
    ingress_with_cidr_blocks = optional(list(map(string)))
    egress_rules             = optional(list(string))
    egress_cidr_blocks       = optional(list(string))
    egress_with_cidr_blocks  = optional(list(map(string)))
  })

  default = null
}

### ECS Cluster related variables
variable "container_insights_enabled" {
  description = "Whether to enable container Insights or not"
  default     = true
  type        = bool
}

### Cloud Map Namespace related variables
variable "namespace_name" {
  description = "The Cloud Map namespace to be created. Should be a valid domain name. Example test.example.local"
  type        = string
  default     = ""
}

variable "namespace_description" {
  description = "Description for the Cloud Map Namespace"
  type        = string
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
