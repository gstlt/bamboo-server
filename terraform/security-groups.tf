resource "aws_security_group" "allow_all_outbound" {
  name = "allow_all_outbound"
  description = "Allow outbound traffic"

  vpc_id = "${aws_vpc.bamboo.id}"

# outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow outbound traffic"
  }
}

resource "aws_security_group" "allow_ssh_ip" {
  name = "allow_ssh_ip"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id = "${aws_vpc.bamboo.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["123.123.123.123/32"]
  }

  tags {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "bamboo_web_server" {
  name = "bamboo web server"
  description = "Allow HTTP and HTTPS traffic in, browser access out."
  vpc_id = "${aws_vpc.bamboo.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.100.0.0/16"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_bamboo_web_server" {
  name = "LB bamboo web server"
  description = "LB lllow HTTPS traffic"
  vpc_id = "${aws_vpc.bamboo.id}"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bamboo_pgsql_rds" {
  name = "Bamboo server"
  description = "Allow access to Postgres RDS"
  vpc_id = "${aws_vpc.bamboo.id}"

  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["${aws_instance.bamboo01.private_ip}/32"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

