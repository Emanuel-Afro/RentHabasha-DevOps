variable "rent_habesha_vpc" {
  type = string
}
variable "enviroment" {
  type = string
}
variable "region" {
  type = string
}
variable "rent_habesha_public_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
variable "rent_habesha_private_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
variable "public_rt" {
  type = string
}
variable "private_rt" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "worker_node_policy" {
  type = map(string)
}