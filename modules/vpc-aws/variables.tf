variable "prefix" {
    description = "Module Prefix"
    default = "AWS-Network"
}

variable "network_cidr" {
  description = "CIDR for the Netword"
  default = "10.0.0.0/16"
}
variable "network_tags" {
  description = "Netword tags"
  type        = map(string)
}

variable "num_private_subnets" {
  description = "Num of private subnets"
  default = 1
}

variable "num_public_subnets" {
  description = "Num of public subnets"
  default = 1
}

variable "subnets_tags" {
  description = "Netword tags"
  type        = map(string)
}

variable "enable_nat_gateway" {
  description = "Enable Nat Gateway for private Network"
  type = bool
  default = false
}

