output "vpn_public_ip" {
  value = aws_instance.vpn_server.public_ip
}

output "private_ec2_ip" {
  value = aws_instance.private_ec2.private_ip
}