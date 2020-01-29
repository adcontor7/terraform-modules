output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnets_cidr_blocks" {
  value = aws_subnet.public-subnet.*.cidr_block
}
output "public_subnets_ids" {
  value = aws_subnet.public-subnet.*.id
}

output "private_subnets_cidr_blocks" {
  value = aws_subnet.private-subnet.*.cidr_block
}
output "private_subnets_ids" {
  value = aws_subnet.private-subnet.*.id
}

#output "vpc_nat_public_ip" {
#  value = aws_eip.nat.public_ip
#}