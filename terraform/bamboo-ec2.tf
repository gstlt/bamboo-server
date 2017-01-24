resource "aws_instance" "bamboo01" {
    ami = "${var.bamboo_ami}"
    instance_type = "t2.xlarge"
    subnet_id = "${aws_subnet.public_1a.id}"
    vpc_security_group_ids = [
      "${aws_security_group.bamboo_web_server.id}",
      "${aws_security_group.allow_ssh_ip.id}",
      "${aws_security_group.allow_all_outbound.id}"
    ]
    # See ssh-keypairs.tf
    key_name = "bamboo_key"

    # root device size 100GB
    root_block_device {
        volume_type = "standard"
        volume_size = 100
    }

    tags {
        Name = "Bamboo server"
    }
}

# SSL for bamboo - need to be created first, this will just access the data
data "aws_acm_certificate" "bamboo_cert" {
  domain = "bamboo.mysuperdomain.com"
}

# Load-balancer definition
resource "aws_elb" "bamboo-elb" {
  name = "bamboo-elb"
  subnets = ["${aws_subnet.public_1a.id}"]
  security_groups = ["${aws_security_group.lb_bamboo_web_server.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.bamboo_cert.arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:80"
    interval = 30
  }

  instances = ["${aws_instance.bamboo01.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "Bamboo ELB"
  }
}

