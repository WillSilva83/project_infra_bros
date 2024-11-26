output "out_subnet_id" {
    value = aws_subnet.public_subnet.id
}

output "vpc_id" {
    value = aws_vpc.vpc_main.id
  
}