resource "aws_vpc" "testApp01-vpc" {
  cidr_block = var.vpc_cidr
  
}

#Blocking the default security group from doing anything.
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.testApp01-vpc.id

  ingress {
    protocol  = "1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}


  resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.testApp01-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
    tags = {
    Name = "PublicSubnet ${count.index + 1}"
  }

}

resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.testApp01-vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "PrivateSubnet ${count.index + 1}"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for load balancer"
  vpc_id      = aws_vpc.testApp01-vpc.id

}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group_rule" "alb_cloudfront_https_ingress_only" {
  security_group_id = aws_security_group.lb_sg.id
  description       = "Allow HTTPS access only from CloudFront CIDR blocks"
  from_port         = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  to_port           = 443
  type              = "ingress"
}

 resource "aws_security_group_rule" "home-IP-ingress" {
  security_group_id = aws_security_group.lb_sg.id
  description       = "Allow HTTPS access only from CloudFront CIDR blocks"
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
  type              = "ingress"
  cidr_blocks =  ["82.3.43.180/32"]
}

resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg"
  vpc_id      = aws_vpc.testApp01-vpc.id

  ingress {
    from_port   = var.api_port
    to_port     = var.api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.testApp01-vpc.id
}

resource "aws_route_table" "internet-access-rt" {
  vpc_id = aws_vpc.testApp01-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.internet-access-rt.id
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name = "${var.namespace}_NATGateway_${count.index}_${var.environment}"
  }
}

resource "aws_eip" "nat_gateway" {
  count = var.az_count
}


