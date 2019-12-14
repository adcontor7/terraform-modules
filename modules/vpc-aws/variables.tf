variable "prefix" {
    description = "Module Prefix"
    default = "AWS-Network"
}

variable "network_cidr" {
  description = "CIDR for the Netword"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "enable_nat_gateway" {
  description = "Enable Nat Gateway for private Network"
  type = bool
  default = true
}

