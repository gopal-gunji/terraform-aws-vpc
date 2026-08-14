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
        }
        var.public_subnet_tags
        

} 