variable "project_id" {
  description = "project id"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  default = "my-terraform-cluster"
}

variable "region" {
  description = "Region where the GKE cluster is going to be deployed"
  default = "europe-west3"
}

#variable "gke_username" {
#  default     = ""
#  description = "gke username"
#}

#variable "gke_password" {
#  default     = ""
#  description = "gke password"
#}

variable "gke_num_nodes" {
  description = "Number of gke nodes"
  default     = 1
}

variable "machine_type" {
  description = "Machine type to be used"
  default = "e2-medium"
}