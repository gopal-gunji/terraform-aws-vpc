resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # VPC association 
  tags = local.igw_final_tags
}

# public subnet
resource "aws_subnet" "public" {
  count     = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
        local.common_tags,
        # roboshop-dev-public_us_east_1a
        {
          Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        },
        var.public_subnet_tags
  )  

} 

# private subnet
resource "aws_subnet" "private" {
  count     = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]


  tags = merge(
        local.common_tags,
        # roboshop-dev-private_us_east_1a
        {
          Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        },
        var.private_subnet_tags
  )  

} 

# database subnet
resource "aws_subnet" "database" {
  count     = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]


  tags = merge(
    local.common_tags,
    # roboshop-dev-database_us_east_1a
    {
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    },
    var.database_subnet_tags
  )  

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        # roboshop-dev-private
        {
          Name = "${var.project}-${var.environment}-private"
        },
        var.private_route_table_tags
  ) 
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        # roboshop-dev-database
        {
          Name = "${var.project}-${var.environment}-database"
        },
        var.database_route_table_tags
  ) 
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        # roboshop-dev-public
        {
          Name = "${var.project}-${var.environment}-public"
        },
        var.public_route_table_tags
  ) 
}