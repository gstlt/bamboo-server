resource "aws_vpc" "bamboo" {
    cidr_block = "10.100.0.0/16"

    tags {
        Name = "Bamboo VPC"
    }
}

resource "aws_subnet" "public_1a" {
    vpc_id = "${aws_vpc.bamboo.id}"
    cidr_block = "10.100.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.region}a"

    tags {
        Name = "Public 1A"
    }
}

resource "aws_subnet" "public_1b" {
    vpc_id = "${aws_vpc.bamboo.id}"
    cidr_block = "10.100.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.region}b"

    tags {
        Name = "Public 1B"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.bamboo.id}"

    tags {
        Name = "Bamboo Internet gw"
    }
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.bamboo.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
}
