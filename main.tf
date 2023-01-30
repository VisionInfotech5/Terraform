provider "aws" {
	region = var.region
	access_key = var.acckey
	secret_key = var.seckey
}

resource "aws_vpc" "test-vpc" {
	cidr_block = "10.10.0.0/16"
	tags = {
		Name = "test-vpc"
	}
}

resource "aws_subnet" "subnet-1" {
	vpc_id = "${aws_vpc.test-vpc.id}"
	cidr_block = "10.10.1.0/24"
	availability_zone = "ap-southeast-2a"
	tags = {
		Name = "subnet-1"
	}
}

resource "aws_subnet" "subnet-2" {
	vpc_id = "${aws_vpc.test-vpc.id}"
	cidr_block = "10.10.2.0/24"
	availability_zone = "ap-southeast-2b"
	tags = {
		Name = "subnet-2"
	}
}

resource "aws_internet_gateway" "test-igw" {
	vpc_id = "${aws_vpc.test-vpc.id}"
	tags = {
		Name = "test-igw"
	}
}

resource "aws_route_table" "public-rt" {
	vpc_id = "${aws_vpc.test-vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.test-igw.id}"
	}
}


resource "aws_route_table_association" "public-routing" {
        subnet_id = "${aws_subnet.subnet-1.id}"
        route_table_id = "${aws_route_table.test-vpc-public-rt.id}"
}


resource "aws_route_table_association" "public-routing-2" {
        subnet_id = "${aws_subnet.subnet-2.id}"
        route_table_id = "${aws_route_table.test-vpc-public-rt.id}"
}


