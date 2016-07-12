provider "aws" {
    alias = "us-west-2"

    region = "us-west-2"
}

resource "aws_vpc" "default" {
    provider = "aws.us-west-2"

    cidr_block = "172.30.0.0/16"

    tags {
        Name = "${var.environment}"
        Environment = "${var.environment}"
        Hero = "mitchellh"
    }
}

resource "aws_internet_gateway" "default" {
    provider = "aws.us-west-2"

	vpc_id = "${aws_vpc.default.id}"

    tags {
        Environment = "${var.environment}"
    }
}

resource "aws_eip" "nat" {
    provider = "aws.us-west-2"

	vpc = true
}

resource "aws_nat_gateway" "nat" {
    provider = "aws.us-west-2"
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.us-west-2b-public.id}"
    depends_on = ["aws_internet_gateway.default"]
}

# Public subnets

resource "aws_subnet" "us-west-2a-public" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.0.0/22"
    availability_zone = "us-west-2a"

    tags {
        Name = "us-west-2a-public"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "us-west-2b-public" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.4.0/22"
    availability_zone = "us-west-2b"

    tags {
        Name = "us-west-2b-public"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "us-west-2c-public" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.8.0/22"
    availability_zone = "us-west-2c"

    tags {
        Name = "us-west-2c-public"
        Environment = "${var.environment}"
    }
}

# Public routes

resource "aws_route_table" "us-west-2-public" {
    provider = "aws.us-west-2"

	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
	}

    tags {
        Name = "us-west-2-public"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "us-west-2a-public" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2a-public.id}"
	route_table_id = "${aws_route_table.us-west-2-public.id}"
}

resource "aws_route_table_association" "us-west-2b-public" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2b-public.id}"
	route_table_id = "${aws_route_table.us-west-2-public.id}"
}

resource "aws_route_table_association" "us-west-2c-public" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2c-public.id}"
	route_table_id = "${aws_route_table.us-west-2-public.id}"
}

# Private subnets

resource "aws_subnet" "us-west-2a-private" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.16.0/20"
    availability_zone = "us-west-2a"

    tags {
        Name = "us-west-2a-private"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "us-west-2b-private" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.32.0/20"
    availability_zone = "us-west-2b"

    tags {
        Name = "us-west-2b-private"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "us-west-2c-private" {
    provider = "aws.us-west-2"

    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "172.30.48.0/20"
    availability_zone = "us-west-2c"

    tags {
        Name = "us-west-2c-private"
        Environment = "${var.environment}"
    }
}

# Private routes

resource "aws_route_table" "us-west-2-private" {
    provider = "aws.us-west-2"

	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.nat.id}"
	}

    tags {
        Name = "us-west-2-private"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "us-west-2a-private" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2a-private.id}"
	route_table_id = "${aws_route_table.us-west-2-private.id}"
}

resource "aws_route_table_association" "us-west-2b-private" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2b-private.id}"
	route_table_id = "${aws_route_table.us-west-2-private.id}"
}

resource "aws_route_table_association" "us-west-2c-private" {
    provider = "aws.us-west-2"

	subnet_id = "${aws_subnet.us-west-2c-private.id}"
	route_table_id = "${aws_route_table.us-west-2-private.id}"
}