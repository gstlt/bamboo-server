variable "region" {
    type = "string"
    default = "eu-central-1"
}

variable "bamboo_ami" {
    type = "string"
    default = "ami-07a16c68"
}

variable "bamboo_db_passwd" {
    type = "string"
}

variable "aws_access_key" {
    type = "string"
}

variable "aws_secret_key" {
    type = "string"
}

