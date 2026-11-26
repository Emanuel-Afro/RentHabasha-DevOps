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

variable "rent_habesha_vpc" {
  type = string
}
variable "rent_habesha_alb_ingress_rule" {
  type = map(object({
    cidr_ipv4 = string
    to_port = string
    from_port = string
    ip_protocol = string
  }))
}