//------referencing subnet from networking module to the extternals
output "rent_habesha_vpc"{
  value = aws_vpc.rent_habesha_vpc.id
}
output "rent_habesha_private_subnet" {
  value = [for subnet in aws_subnet.rent_habesha_private_subnet : subnet.id]
}
