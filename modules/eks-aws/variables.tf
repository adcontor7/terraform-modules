variable "create_eks" {
  default = true
  type    = bool
}



variable "cluster_name" {
  type    = string
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}
variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "iam_role_name" {
  description = "IAM role name for the cluster"
  type        = string
  default     = ""
}

variable "iam_role_arn" {
  description = "IAM role ARN for the cluster"
  type        = string
  default     = ""
}

variable "kubeconfig_name" {
  description = "Override the default name used for items kubeconfig."
  type        = string
  default     = ""
}


variable "write_kubeconfig" {
  default = true
  type    = bool
}

variable "config_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Assumed to be a directory if the value ends with a forward slash `/`."
  type        = string
  default     = "./"
}

