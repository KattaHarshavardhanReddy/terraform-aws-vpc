resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = "default"

  tags = merge (
    var.common_tags,
    {
        Name = local.resource_name
    }
  )
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.common_tags,
    var.igw_tags,
    {
        Name = local.resource_name
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index] 
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = "true"

  tags = merge (
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.resource_name}- public - ${local.azs[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index] 
  availability_zone = local.azs[count.index]
  
  tags = merge (
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.resource_name}- private - ${local.azs[count.index]}"
    }
  )
}

resource "aws_eip" "nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "natgate" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_tags,
    {
    Name = "${local.resource_name}"
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.route_table_public,
    {
    Name = "${local.resource_name}-public"
  }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.route_table_private,
    {
    Name = "${local.resource_name}-private"
  }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgate.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}