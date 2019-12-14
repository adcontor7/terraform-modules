output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_nat_public_ip" {
  value = aws_eip.nat.public_ip
}