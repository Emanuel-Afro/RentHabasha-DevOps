variable "enviroment" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "rent_habesha_private_subnet"{
  type = list(string)
}
variable "worker_node_policy" {
  type = map(string)
}