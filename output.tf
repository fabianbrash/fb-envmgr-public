output "instance_name" {
  value = aws_instance.example_ec2.tags["Name"]
  description = "The name of the EC2 instance"
}

output "instance_public_ip" {
  value = aws_instance.example_ec2.public_ip
  description = "The public IP address of the EC2 instance"
}

output "vpc_id" {
  value = aws_subnet.example_subnet.vpc_id
  description = "The VPC ID where the instance is deployed"
}

output "subnet_id" {
  value = aws_instance.example_ec2.subnet_id
  description = "The subnet ID where the instance is deployed"
}

output "vpc_arn" {
  value = aws_vpc.example_vpc.arn
  description = "Your VPC ARN"
}

output "ec2_instance_dns" {
  value = aws_instance.example_ec2.public_dns
  description = "Your instances public DNS"
}