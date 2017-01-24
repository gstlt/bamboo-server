output "bamboo_ec2_ip_address" {
  value = ["${aws_instance.bamboo01.public_ip}"]
}

output "bamboo_db_address" {
  value = ["${aws_db_instance.bamboo-pgsql-rds.address}"]
}

output "bamboo_elb_dns_name" {
  value = ["${aws_elb.bamboo-elb.dns_name}"]
}
