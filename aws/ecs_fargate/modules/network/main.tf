data "aws_availability_zones" "aws_az" {
  state = "available"
}

# create vpc
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}

# create subnets
resource "aws_subnet" "subnets" {
  count = length(data.aws_availability_zones.aws_az.names)

  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.aws_az.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.app_name}-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-igw"
    Environment = var.app_environment
  }
}

# create routes
resource "aws_route_table" "all_routes" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.app_name}-route-table"
    Environment = var.app_environment
  }
}

resource "aws_main_route_table_association" "vpc_routes" {
  vpc_id = aws_vpc.vpc.id
  route_table_id = aws_route_table.all_routes.id
}