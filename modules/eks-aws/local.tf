locals {
  kubeconfig_name     = var.kubeconfig_name == "" ? var.cluster_name : var.kubeconfig_name
}