resource "aws_db_subnet_group" "bamboo_db" {
    name = "main"
    description = "Our main group of subnets"
    subnet_ids = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1b.id}"]
    tags {
        Name = "MyApp DB subnet group"
    }
}


resource "aws_db_instance" "bamboo-pgsql-rds" {
    identifier = "bamboo-pgsql-rds"
    allocated_storage = 20
    engine = "postgres"
    engine_version = "9.5.4"
    instance_class = "db.t2.small"
    name = "bamboodb"
    username = "bamboo"
    password = "${var.bamboo_db_passwd}"
    vpc_security_group_ids = ["${aws_security_group.bamboo_pgsql_rds.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.bamboo_db.id}"

    backup_retention_period = 7
    backup_window = "01:00-07:00"
}

